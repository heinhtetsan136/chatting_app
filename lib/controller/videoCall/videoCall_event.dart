abstract class VideocallEvent {
  const VideocallEvent();
}

class VideocallJoinEvent extends VideocallEvent {
  final String receiverId;
  const VideocallJoinEvent(this.receiverId);
}

class VideocallEndEvent extends VideocallEvent {
  const VideocallEndEvent();
}
