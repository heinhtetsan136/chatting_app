import 'package:blca_project_app/repo/ui_video_call_Service.dart/video_call_model.dart';
import 'package:blca_project_app/repo/user_model.dart';
import 'package:equatable/equatable.dart';

abstract class VideoCallDbState extends Equatable {
  final ContactUser? caller;
  final VideoCallModel? model;
  const VideoCallDbState([this.caller, this.model]);
  @override
  List<Object?> get props => [caller, DateTime.now, model?.callState];
}

class VideoCallDbInitialState extends VideoCallDbState {
  const VideoCallDbInitialState();
}

class VideoCallDbIncomingState extends VideoCallDbState {
  @override
  final VideoCallModel model;
  const VideoCallDbIncomingState(super.caller, this.model);
}

class VideoCallDbLoadingState extends VideoCallDbState {
  const VideoCallDbLoadingState(super.caller);
}

class VideoCallWaitingState extends VideoCallDbState {
  const VideoCallWaitingState(super.caller);
}

class VideoCallTimeOutState extends VideoCallDbState {
  const VideoCallTimeOutState();
}

class VideoCallDbLeaveState extends VideoCallDbState {
  const VideoCallDbLeaveState();
}

class VideoCalDbErrorState extends VideoCallDbState {
  final String message;
  const VideoCalDbErrorState(this.message);
}

class VideoCallDbRejectState extends VideoCallDbState {
  const VideoCallDbRejectState();
}

class VideoCallDbSucessState extends VideoCallDbState {
  @override
  final VideoCallModel model;
  const VideoCallDbSucessState(this.model);
}
