import 'package:blca_project_app/controller/videoCall/videoCall_Event.dart';
import 'package:blca_project_app/controller/videoCall/videoCall_State.dart';
import 'package:blca_project_app/injection.dart';
import 'package:blca_project_app/repo/agoraService/agoraService.dart';
import 'package:blca_project_app/repo/authService.dart';
import 'package:blca_project_app/repo/ui_video_call_Service.dart/ui_video_call_Service.dart';
import 'package:blca_project_app/repo/ui_video_call_Service.dart/video_call_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum callState { rejected, calling, callEnded, accepted }

class VideocallBloc extends Bloc<VideocallEvent, VideoCallBaseState> {
  final AuthService _authService = Injection<AuthService>();
  final VideoCallService _videoCallService = Injection<VideoCallService>();
  final AgoraService _agoraService = Injection<AgoraService>();

  late AgoraHandler handler;
  VideocallBloc(
    super.initialState,
  ) {
    _videoCallService.contactListener(contactListener);
    on<VideocallJoinEvent>((event, emit) async {
      final user = _authService.currentUser;
      final result = await _videoCallService.createCall(
          VideoCallModelParams.toCreate(
              callerId: user!.uid,
              receiverId: event.receiverId,
              callState: callState.calling.name,
              timeStamp: Timestamp.now()));
      if (result.hasError) {
        emit(VideoCallErrorState(result.error!.message));
      }
      final VideoCallModel model = VideoCallModel.fromJson(result.data);
      await _agoraService.init();
      handler = AgoraHandler.dummy();
      _agoraService.handler = handler;
      await _agoraService.ready();
      final token = await _authService.currentUser!.getIdToken();
      await _agoraService.joinChannel(token!, "336");
      emit(VideocallSucessState());
    });
  }
  void contactListener(VideoCallModel room) {}
}
