import 'package:blca_project_app/repo/ui_video_call_Service.dart/video_call_model.dart';

abstract class VideoCallDbEvent {
  const VideoCallDbEvent();
}

class VideoCallDbCallEvent extends VideoCallDbEvent {
  final String receiverId;
  const VideoCallDbCallEvent(this.receiverId);
}

class VideoCallDbLeaveEvent extends VideoCallDbEvent {
  const VideoCallDbLeaveEvent();
}

class VideoCallDbIncomingEvent extends VideoCallDbEvent {
  final VideoCallModel videoCallModel;
  const VideoCallDbIncomingEvent(this.videoCallModel);
}

class VideoCallDbAcceptedEvent extends VideoCallDbEvent {
  VideoCallDbAcceptedEvent();
}

class VideoCallDbUserJoinedEvent extends VideoCallDbEvent {
  final VideoCallModel videoCallModel;
  VideoCallDbUserJoinedEvent(this.videoCallModel);
}

class VideoCallDbUserRejectedEvent extends VideoCallDbEvent {
  final VideoCallModel videoCallModel;
  VideoCallDbUserRejectedEvent(this.videoCallModel);
}

class VideoCallDbDeclineEvent extends VideoCallDbEvent {
  final String id;
  const VideoCallDbDeclineEvent(this.id);
}
