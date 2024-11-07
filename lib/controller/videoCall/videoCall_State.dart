abstract class VideoCallBaseState {
  const VideoCallBaseState();
}

class VideoCallInitial extends VideoCallBaseState {
  VideoCallInitial();
}

class VideocallSucessState extends VideoCallBaseState {
  VideocallSucessState();
}

class VideocallLoadingState extends VideoCallBaseState {
  VideocallLoadingState();
}

class VideoCallErrorState extends VideoCallBaseState {
  final String message;
  VideoCallErrorState(this.message);
}
