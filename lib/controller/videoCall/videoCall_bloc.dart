import 'dart:async';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:blca_project_app/controller/videoCall/videoCall_Event.dart';
import 'package:blca_project_app/controller/videoCall/videoCall_State.dart';
import 'package:blca_project_app/injection.dart';
import 'package:blca_project_app/logger.dart';
import 'package:blca_project_app/repo/agoraService/agoraService.dart';
import 'package:blca_project_app/repo/authService.dart';
import 'package:blca_project_app/repo/ui_video_call_Service.dart/ui_video_call_Service.dart';
import 'package:blca_project_app/repo/ui_video_call_Service.dart/video_call_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum callState { rejected, calling, callEnded, accepted }

class CallModel {
  String id;
  Timestamp timeStamp;
  CallModel({required this.id}) : timeStamp = Timestamp.now();
}

class AgoraVideocallBloc extends Bloc<VideocallEvent, VideoCallState> {
  final VideoCallModel channel;

  final AuthService _authService = Injection<AuthService>();
  final FirebaseFirestore _firestore = Injection<FirebaseFirestore>();
  final AgoraService _agoraService = Injection<AgoraService>();
  Stream<AgoraLiveConnection> get connectStream => _agoraService.connectStream;
  Stream get remoteId => _agoraService.connectStream;
  StreamSubscription? subscription;
  RtcEngine get engine => _agoraService.engine;
  late AgoraHandler handler;
  AgoraVideocallBloc(super.initialState, this.channel) {
    logger.i("bloc init ${channel.id}");
    subscription = _firestore
        .collection("VideoCall")
        .doc(channel.id)
        .snapshots()
        .listen((event) async {
      final VideoCallModel model = VideoCallModel.fromJson(event.data()!);
      if (model.callState == callState.callEnded.name) {
        add(const VideocallEndEvent());
      }
    });
    on<VideocallJoinEvent>((event, emit) async {
      emit(VideocallLoadingState());

      await _agoraService.init();
      handler = AgoraHandler.dummy();
      _agoraService.handler = handler;
      await _agoraService.ready();
      final token = await _authService.currentUser!.getIdToken();
      await _agoraService.joinChannel(token!, channel.id);
      emit(VideocallSucessState());
    });
    on<VideocallEndEvent>((_, emit) async {
      _agoraService.leaveChannel();

      emit(VideoCallEndState());
    });
    add(VideocallJoinEvent(channel.receiverId));
  }

  @override
  Future<void> close() async {
    logger.i("close bloc  vxx");
    await _agoraService.close();
    subscription?.cancel();

    // TODO: implement close
    return super.close();
  }

  void contactListener(VideoCallModel room) {
    if (room.callState == callState.callEnded) {
      add(const VideocallEndEvent());
    }
  }
}
