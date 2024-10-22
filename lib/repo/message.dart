import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Message extends Equatable {
  final String id;
  final String chatRoomId;
  final String fromUser;

  final String? data;
  final bool isText;
  final Timestamp sendingTime;

  const Message(
      {required this.id,
      required this.chatRoomId,
      required this.fromUser,
      required this.data,
      this.isText = true,
      required this.sendingTime});
  factory Message.fromJson(dynamic data) {
    return Message(
        id: data["id"],
        chatRoomId: data["chatRoomId"],
        fromUser: data["fromUser"],
        data: data["data"] ?? "",
        isText: data["isText"],
        sendingTime: data["sendingTime"]);
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "chatRoomId": chatRoomId,
      "fromUser": fromUser,
      "data": data,
      "isText": isText,
      "sendingTime": sendingTime,
    };
  }

  @override
  bool operator ==(covariant Message other) {
    // TODO: implement ==
    return id == other.id;
  }

  @override
  // TODO: implement hashCode
  int get hashCode => id.hashCode;

  @override
  // TODO: implement props
  List<Object?> get props => [id, data, sendingTime];
}

class MessageParams {
  final String chatRoomId;
  final String fromUser;

  final String data;
  final bool isText;
  MessageParams(
      {required this.chatRoomId,
      required this.fromUser,
      required this.data,
      required this.isText});
  factory MessageParams.toCreate({
    required String chatRoomId,
    required String fromUser,
    data = "",
    isText = true,
  }) {
    return MessageParams(
        chatRoomId: chatRoomId, fromUser: fromUser, data: data, isText: isText);
  }
  Map<String, dynamic> toCreate() {
    return {
      "chatRoomId": chatRoomId,
      "fromUser": fromUser,
      "data": data,
      "isText": isText
    };
  }
}
