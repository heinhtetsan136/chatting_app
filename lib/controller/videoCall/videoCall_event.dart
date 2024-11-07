abstract class VideocallEvent {
  const VideocallEvent();
}

class VideocallJoinEvent extends VideocallEvent {
  final String receiverId;
  const VideocallJoinEvent(this.receiverId);
}

class VideocallRejectedEvent extends VideocallEvent {
  const VideocallRejectedEvent();
}

class VideocallEndEvent extends VideocallEvent {
  const VideocallEndEvent();
}

class VideocallAcceptedEvent extends VideocallEvent {
  const VideocallAcceptedEvent();
}
