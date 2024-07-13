class ChatRoom {
  final String id;
  final String finalMessage;
  final String toUserId;
  final String? photoUrl;
  final DateTime time;
  final List member;
  final String? toUserName;
  final String fromUserId;

  ChatRoom({
    required this.id,
    required this.member,
    required this.finalMessage,
    this.photoUrl,
    required this.time,
    this.toUserName,
    required this.fromUserId,
    required this.toUserId,
  });
  factory ChatRoom.fromJson(dynamic data) {
    return ChatRoom(
      id: data["id"],
      finalMessage: data["text"],
      photoUrl: data["photoUrl"],
      member: data["member"] ?? [],
      time: DateTime.parse(data["time"]),
      fromUserId: data["fromUserId"],
      toUserId: data["toUserId"] ?? "this is null",
      toUserName: data["toUserName"] ?? "this is username",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "text": finalMessage,
      "photoUrl": photoUrl,
      "member": member,
      "time": time.toIso8601String(),
      "fromUserId": fromUserId,
      "toUserId": toUserId,
      "toUserName": toUserName
    };
  }
}

class ChatRoomParams {
  final String finalMessage;
  final String? photoUrl;
  final List member;
  final String toUserName;
  final String fromUserId;
  final String toUserId;

  ChatRoomParams({
    required this.toUserId,
    required this.finalMessage,
    required this.member,
    this.photoUrl,
    required this.fromUserId,
    required this.toUserName,
  });
  factory ChatRoomParams.toCreate({
    required String text,
    required List<String> member,
    required String formUserId,
    required String toUserId,
    required String toUserName,
  }) {
    return ChatRoomParams(
        toUserName: toUserName,
        finalMessage: text,
        fromUserId: formUserId,
        member: member,
        toUserId: toUserId);
  }
  Map<String, dynamic> toCreate() {
    return {
      "member": member,
      "text": finalMessage,
      "photoUrl": photoUrl,
      "fromUserId": fromUserId,
      "time": DateTime.now().toIso8601String(),
      "toUserId": toUserId,
      "toUserName": toUserName
    };
  }
}
