abstract class VideoCallState {
  const VideoCallState();
}

class VideoCallInitial extends VideoCallState {
  VideoCallInitial();
}

class VideocallSucessState extends VideoCallState {
  VideocallSucessState();
}

class VideocallLoadingState extends VideoCallState {
  VideocallLoadingState();
}

class VideoCallEndState extends VideoCallState {
  VideoCallEndState();
}

class VideoCallErrorState extends VideoCallState {
  final String message;
  VideoCallErrorState(this.message);
}
