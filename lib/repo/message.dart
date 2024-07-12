class Message {
  final String message;
  final String receiver;
  final String type;
  final DateTime time;

  Message(
      {required this.message,
      required this.receiver,
      required this.type,
      required this.time});
  factory Message.fromJson(dynamic data) {
    return Message(
        message: data["message"],
        receiver: data["receiver"],
        type: data["type"],
        time: DateTime.parse(data["time"]));
  }
}
