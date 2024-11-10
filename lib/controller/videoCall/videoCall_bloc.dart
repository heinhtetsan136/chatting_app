import 'package:blca_project_app/controller/videoCall/videoCall_Event.dart';
import 'package:blca_project_app/controller/videoCall/videoCall_State.dart';
import 'package:blca_project_app/injection.dart';
import 'package:blca_project_app/logger.dart';
import 'package:blca_project_app/repo/agoraService/agoraService.dart';
import 'package:blca_project_app/repo/authService.dart';
import 'package:blca_project_app/repo/ui_video_call_Service.dart/ui_video_call_Service.dart';
import 'package:blca_project_app/repo/ui_video_call_Service.dart/video_call_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum callState { rejected, calling, callEnded, accepted }

class AgoraVideocallBloc extends Bloc<VideocallEvent, VideoCallState> {
  final String channel;
  final AuthService _authService = Injection<AuthService>();
  final VideoCallService _videoCallService = Injection<VideoCallService>();
  final AgoraService _agoraService = Injection<AgoraService>();
  Stream get remoteId => _agoraService.remotId;
  late AgoraHandler handler;
  AgoraVideocallBloc(super.initialState, this.channel) {
    _videoCallService.contactListener(contactListener);
    on<VideocallJoinEvent>((event, emit) async {
      emit(VideocallLoadingState());

      await _agoraService.init();
      handler = AgoraHandler.dummy();
      _agoraService.handler = handler;
      await _agoraService.ready();
      final token = await _authService.currentUser!.getIdToken();
      await _agoraService.joinChannel(token!, channel);
      emit(VideocallSucessState());
    });
    on<VideocallEndEvent>((_, emit) {
      _agoraService.leaveChannel();
      _agoraService.dispose();
    });
  }

  @override
  Future<void> close() async {
    logger.i("close bloc");
    await _agoraService.dispose();
    // TODO: implement close
    return super.close();
  }

  void contactListener(VideoCallModel room) {}
}
