import 'package:blca_project_app/logger.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRoom {
  final String id;
  final String finalMessage;
  final Timestamp? finalMessageDateTime;
  final String toUserId;
  final String? photoUrl;
  final DateTime time;
  final List member;
  final String? toUserName;
  final String fromUserId;
  final Timestamp updated_At;

  ChatRoom({
    required this.updated_At,
    this.finalMessageDateTime,
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
    logger.wtf(data["updated_At"]);
    return ChatRoom(
      finalMessageDateTime: data["finalMessageDateTime"],
      updated_At: data["updated_At"],
      id: data["id"],
      finalMessage: data["finalMessage"],
      photoUrl: data["photoUrl"],
      member: data["member"] ?? [],
      time: DateTime.parse(data["time"]),
      fromUserId: data["fromUserId"],
      toUserId: data["toUserId"] ?? "this is null",
      toUserName: data["toUserName"] ?? "this is username",
    );
  }
  @override
  bool operator ==(covariant ChatRoom other) {
    // TODO: implement ==
    return id == other.id;
  }

  @override
  // TODO: implement hashCode
  int get hashCode => id.hashCode;

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "text": finalMessage,
      "finalMessageDateTime": finalMessageDateTime,
      "photoUrl": photoUrl,
      "member": member,
      "time": time.toIso8601String(),
      "fromUserId": fromUserId,
      "toUserId": toUserId,
      "toUserName": toUserName,
      "updated_At": updated_At,
    };
  }
}

class ChatRoomParams {
  final String finalMessage;
  final Timestamp finalMessageDateTime;
  final String? photoUrl;
  final List member;
  final String toUserName;
  final String fromUserId;
  final String toUserId;
  final Timestamp Updated_At;

  ChatRoomParams({
    required this.toUserId,
    required this.finalMessage,
    required this.finalMessageDateTime,
    required this.member,
    this.photoUrl,
    required this.fromUserId,
    required this.toUserName,
    required this.Updated_At,
  });
  factory ChatRoomParams.toCreate({
    required String finalMessage,
    required Timestamp finalMessageDateTime,
    required List<String> member,
    required String formUserId,
    required String toUserId,
    required String toUserName,
    required Timestamp Updated_At,
  }) {
    return ChatRoomParams(
        finalMessageDateTime: finalMessageDateTime,
        Updated_At: Updated_At,
        toUserName: toUserName,
        finalMessage: finalMessage,
        fromUserId: formUserId,
        member: member,
        toUserId: toUserId);
  }
  Map<String, dynamic> toCreate() {
    return {
      "member": member,
      "finalMessage": finalMessage,
      "photoUrl": photoUrl,
      "fromUserId": fromUserId,
      "time": DateTime.now().toIso8601String(),
      "toUserId": toUserId,
      "toUserName": toUserName,
      "updated_At": Updated_At,
      "finalMessageDateTime": finalMessageDateTime
    };
  }
}
