class Messages {
  final String message;
  final String receiver;
  final String type;
  final DateTime time;

  Messages(
      {required this.message,
      required this.receiver,
      required this.type,
      required this.time});
  factory Messages.fromJson(dynamic data) {
    return Messages(
        message: data["message"],
        receiver: data["receiver"],
        type: data["type"],
        time: DateTime.parse(data["time"]));
  }
}
