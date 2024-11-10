import 'dart:async';

import 'package:blca_project_app/controller/videoCall/db_controller/video_call_db_event.dart';
import 'package:blca_project_app/controller/videoCall/db_controller/video_call_db_state.dart';
import 'package:blca_project_app/injection.dart';
import 'package:blca_project_app/logger.dart';
import 'package:blca_project_app/repo/authService.dart';
import 'package:blca_project_app/repo/firestoreService.dart';
import 'package:blca_project_app/repo/ui_video_call_Service.dart/ui_video_call_Service.dart';
import 'package:blca_project_app/repo/ui_video_call_Service.dart/video_call_model.dart';
import 'package:blca_project_app/repo/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum callState { rejected, calling, callEnded, accepted, miss }

class VideoCall {
  final VideoCallModel model;
  final String callState;

  VideoCall({required this.model, required this.callState});
}

List<VideoCallModel> videoCallList = [];
VideoCallModel? model;

class VideoCallDbBlco extends Bloc<VideoCallDbEvent, VideoCallDbState> {
  final ContactUserService contactUserService = Injection<ContactUserService>();
  final VideoCallService _videoCallService = Injection<VideoCallService>();
  final FirebaseFirestore _db = Injection<FirebaseFirestore>();
  final AuthService _authService = Injection<AuthService>();
  late final VideoCall videoCall;
  VideoCallDbBlco() : super(VideoCallDbInitialState()) {
    _videoCallService.contactListener(contactListener);
    on<VideoCallDbCallEvent>((event, emit) async {
      logger.i("call event ${event.receiverId}");
      if (videoCallList.isNotEmpty == true) {
        logger.i("call already event ${event.receiverId}");
        return;
      }
      final otheruser = await contactUserService.getUser(event.receiverId);
      if (otheruser.hasError) {
        emit(VideoCalDbErrorState(otheruser.error!.message.toString()));
        return;
      }
      emit(VideoCallDbLoadingState(ContactUser.fromJson(
        otheruser.data,
      )));
      String callerId = _authService.currentUser!.uid;
      final result = await _videoCallService.createCall(
          VideoCallModelParams.toCreate(
              callerId: callerId,
              receiverId: event.receiverId,
              callState: callState.calling.name,
              timeStamp: Timestamp.now()));

      if (result.hasError) {
        emit(VideoCalDbErrorState(result.error!.message.toString()));
        return;
      }
      final VideoCallModel model = VideoCallModel.fromJson(result.data!);
      videoCallList.add(model);
      await Future.delayed(const Duration(seconds: 30), () async {});
      final check = await _db.collection("VideoCall").doc(model.id).get();
      if (check.data() == null) {
        emit(VideoCalDbErrorState("Time Out"));
        return;
      }
      final VideoCallModel videocallmodel =
          VideoCallModel.fromJson(check.data()!);
      if (videocallmodel.callState != callState.accepted.name) {
        add(VideoCallDbLeaveEvent(videocallmodel.id));

        return;
      }
      emit(VideoCallDbSucessState(model));
    });
    on<VideoCallDbLeaveEvent>((event, emit) async {
      String callerId = _authService.currentUser!.uid;
      final result = await _videoCallService.updateCalltate(
          event.id, callState.callEnded.name);
      if (result.hasError) {
        emit(VideoCalDbErrorState(result.error!.message.toString()));
        return;
      }
      videoCallList.removeWhere((element) => element.id == event.id);
      emit(VideoCallDbLeaveState());
    });
    on<VideoCallDbDeclineEvent>((event, emit) async {
      String callerId = _authService.currentUser!.uid;
      final result = await _videoCallService.updateCalltate(
          event.id, callState.rejected.name);
      if (result.hasError) {
        emit(VideoCalDbErrorState(result.error!.message.toString()));
        return;
      }
      emit(VideoCallDbLeaveState());
    });

    on<VideoCallDbAcceptedEvent>((event, emit) async {
      final result = await _videoCallService.updateCalltate(
          event.id, callState.accepted.name);
      if (result.hasError) {
        emit(VideoCalDbErrorState(result.error!.message.toString()));
        return;
      }

      emit(VideoCallDbSucessState(
        videoCallList.firstWhere((element) => element.id == event.id),
      ));
    });
    on<VideoCallDbIncomingEvent>((event, emit) async {
      final model = event.videoCallModel;
      contactUserService.getListofUser();

      final result = await contactUserService.getUser(model.receiverId);
      if (result.hasError) {
        emit(VideoCalDbErrorState(result.error!.message.toString()));
        return;
      }
      emit(VideoCallDbIncomingState(result.data));
      // emit(VideoCallDbIncomingState(model));
    });
  }

  void contactListener(VideoCallModel p1) {
    if (videoCallList.isNotEmpty != true) {
      videoCallList.add(p1);
      add(VideoCallDbIncomingEvent(p1));
      return;
    }
    add(VideoCallDbDeclineEvent(p1.id));
  }
}
