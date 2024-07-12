import 'package:blca_project_app/repo/user_model.dart';

class ChatRoom {
  final String id;
  final String text;
  final String? photoUrl;
  final DateTime time;
  final String fromUserId;
  final ContactUser toUserId;

  ChatRoom(
      {required this.id,
      required this.text,
      this.photoUrl,
      required this.time,
      required this.fromUserId,
      required this.toUserId});
  factory ChatRoom.fromJson(dynamic data) {
    return ChatRoom(
      id: data["id"],
      text: data["text"],
      photoUrl: data["photoUrl"],
      time: DateTime.parse(data["time"]),
      fromUserId: data["fromUserId"],
      toUserId: data["toUserId"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "text": text,
      "photoUrl": photoUrl,
      "time": time.toIso8601String(),
      "fromUserId": fromUserId,
      "toUserId": toUserId
    };
  }
}

class ChatRoomParams {
  final String text;
  final String? photoUrl;

  final String fromUserId;
  final String toUserId;

  ChatRoomParams(
      {required this.text,
      this.photoUrl,
      required this.fromUserId,
      required this.toUserId});
  factory ChatRoomParams.toCreate(
      {required String text,
      required String id,
      required String formUserId,
      required String toUserId}) {
    return ChatRoomParams(
        text: text, fromUserId: formUserId, toUserId: toUserId);
  }
  Map<String, dynamic> toCreate() {
    return {
      "text": text,
      "photoUrl": photoUrl,
      "fromUserId": fromUserId,
      "toUserId": toUserId,
      "time": DateTime.now().toIso8601String(),
    };
  }
}
