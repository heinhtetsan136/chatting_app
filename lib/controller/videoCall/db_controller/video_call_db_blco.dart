import 'dart:async';

import 'package:blca_project_app/controller/videoCall/db_controller/video_call_db_event.dart';
import 'package:blca_project_app/controller/videoCall/db_controller/video_call_db_state.dart';
import 'package:blca_project_app/injection.dart';
import 'package:blca_project_app/logger.dart';
import 'package:blca_project_app/repo/authService.dart';
import 'package:blca_project_app/repo/firestoreService.dart';
import 'package:blca_project_app/repo/ui_video_call_Service.dart/ui_video_call_Service.dart';
import 'package:blca_project_app/repo/ui_video_call_Service.dart/video_call_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum callState { rejected, calling, callEnded, accepted, miss }

class VideoCall {
  final VideoCallModel model;
  final String callState;

  VideoCall({required this.model, required this.callState});
}

VideoCallModel? model;

class VideoCallDbBlco extends Bloc<VideoCallDbEvent, VideoCallDbState> {
  final ContactUserService contactUserService = Injection<ContactUserService>();
  final VideoCallService _videoCallService = Injection<VideoCallService>();
  final FirebaseFirestore _db = Injection<FirebaseFirestore>();
  final AuthService _authService = Injection<AuthService>();
  VideoCallModel? _videoCall;
  StreamSubscription? subscription;
  List<VideoCallModel> videoCallList = [];
  set videoCallModel(VideoCallModel? model) {
    _videoCall = model;
  }

  Timer? _waitingtimer;
  final Duration _duration = const Duration(seconds: 30);
  VideoCallDbBlco() : super(const VideoCallDbInitialState()) {
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
      emit(VideoCallDbLoadingState(otheruser.data));
      String callerId = _authService.currentUser!.uid;
      final result = await _videoCallService.createCall(
          VideoCallModelParams.toCreate(
              callerId: callerId,
              receiverId: event.receiverId,
              callState: callState.calling.name,
              timeStamp: Timestamp.now()));
      final VideoCallModel model = VideoCallModel.fromJson(result.data!);
      videoCallModel = model;
      if (result.hasError) {
        emit(VideoCalDbErrorState(result.error!.message.toString()));
        return;
      }
      logger.i(
          "call event already event ${model.receiverId} ${model.id} ${model.callState}");
      emit(VideoCallWaitingState(otheruser.data));
      _waitingtimer?.cancel();
      _waitingtimer = Timer(_duration, () {
        add(const VideoCallDbLeaveEvent());
      });
      _listenToVideoCallStream(model.id, emit);
    });
    on<VideoCallDbUserJoinedEvent>((event, emit) async {
      emit(VideoCallDbSucessState(event.videoCallModel));
    });
    on<VideoCallDbLeaveEvent>((event, emit) async {
      if (_videoCall == null) {
        return;
      }
      logger.i("$videoCallList");
      String callerId = _authService.currentUser!.uid;
      final result = await _videoCallService.updateCalltate(
          _videoCall!.id, callState.callEnded.name);
      if (result.hasError) {
        emit(VideoCalDbErrorState(result.error!.message.toString()));
        return;
      }
      _videoCall = null;
      emit(const VideoCallDbLeaveState());
    });
    on<VideoCallDbDeclineEvent>((event, emit) async {
      String callerId = _authService.currentUser!.uid;
      final result = await _videoCallService.updateCalltate(
          event.id, callState.rejected.name);
      if (result.hasError) {
        emit(VideoCalDbErrorState(result.error!.message.toString()));
        return;
      }
      _videoCall = null;
      emit(const VideoCallDbLeaveState());
    });
    on<VideoCallDbUserRejectedEvent>((event, emit) {
      logger.i("call event rejected State ${event.videoCallModel.id}");
      _videoCall = null;
      emit(const VideoCallDbRejectState());
    });
    on<VideoCallDbAcceptedEvent>((event, emit) async {
      final result = await _videoCallService.updateCalltate(
          _videoCall!.id, callState.accepted.name);
      if (result.hasError) {
        emit(VideoCalDbErrorState(result.error!.message.toString()));
        return;
      }

      emit(VideoCallDbSucessState(
        _videoCall!,
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
      videoCallModel = model;
      emit(VideoCallDbIncomingState(result.data, event.videoCallModel));
      // emit(VideoCallDbIncomingState(model));
    });
  }

  void contactListener(VideoCallModel p1) {
    logger.i("videocalldb it ${p1.callState}  $_videoCall");
    logger.i("video call $_videoCall");
    if (_videoCall == null) {
      _videoCall = p1;
      add(VideoCallDbIncomingEvent(p1));
      return;
    }
    add(VideoCallDbDeclineEvent(p1.id));
  }

  void _listenToVideoCallStream(
      String id, Emitter<VideoCallDbState> emit) async {
    subscription =
        _db.collection("VideoCall").doc(id).snapshots().listen((event) {
      final VideoCallModel model = VideoCallModel.fromJson(event.data()!);
      if (model.callState == callState.accepted.name) {
        _waitingtimer?.cancel();
        add(VideoCallDbUserJoinedEvent(model));
        subscription?.cancel();
        return;
      }
      if (model.callState == callState.rejected.name) {
        _waitingtimer?.cancel();
        subscription?.cancel();
        add(VideoCallDbUserRejectedEvent(model));
        return;
      }
    });
  }
}
