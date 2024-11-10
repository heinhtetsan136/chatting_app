import 'package:blca_project_app/repo/ui_video_call_Service.dart/video_call_model.dart';
import 'package:blca_project_app/repo/user_model.dart';

abstract class VideoCallDbState {
  const VideoCallDbState();
}

class VideoCallDbInitialState extends VideoCallDbState {
  VideoCallDbInitialState();
}

class VideoCallDbIncomingState extends VideoCallDbState {
  final ContactUser caller;
  VideoCallDbIncomingState(this.caller);
}

class VideoCallDbLoadingState extends VideoCallDbState {
  final ContactUser caller;
  VideoCallDbLoadingState(this.caller);
}

class VideoCallDbLeaveState extends VideoCallDbState {
  VideoCallDbLeaveState();
}

class VideoCalDbErrorState extends VideoCallDbState {
  final String message;
  VideoCalDbErrorState(this.message);
}

class VideoCallDbSucessState extends VideoCallDbState {
  final VideoCallModel model;
  VideoCallDbSucessState(this.model);
}
