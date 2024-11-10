import 'package:blca_project_app/repo/ui_video_call_Service.dart/video_call_model.dart';

abstract class VideoCallDbEvent {
  const VideoCallDbEvent();
}

class VideoCallDbCallEvent extends VideoCallDbEvent {
  final String receiverId;
  const VideoCallDbCallEvent(this.receiverId);
}

class VideoCallDbLeaveEvent extends VideoCallDbEvent {
  final String id;
  const VideoCallDbLeaveEvent(this.id);
}

class VideoCallDbIncomingEvent extends VideoCallDbEvent {
  final VideoCallModel videoCallModel;
  const VideoCallDbIncomingEvent(this.videoCallModel);
}

class VideoCallDbAcceptedEvent extends VideoCallDbEvent {
  final String id;
  VideoCallDbAcceptedEvent(this.id);
}

class VideoCallDbDeclineEvent extends VideoCallDbEvent {
  final String id;
  const VideoCallDbDeclineEvent(this.id);
}
