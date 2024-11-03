import 'dart:async';

import 'package:blca_project_app/injection.dart';
import 'package:blca_project_app/logger.dart';
import 'package:blca_project_app/model/error.dart';
import 'package:blca_project_app/model/result.dart';
import 'package:blca_project_app/repo/authService.dart';
import 'package:blca_project_app/repo/chatRoom_model.dart';
import 'package:blca_project_app/repo/message.dart';
import 'package:blca_project_app/repo/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRoomService {
  StreamSubscription? chatRoomStream;
  final AuthService _authService = Injection.get<AuthService>();
  final FirebaseFirestore db = Injection.get<FirebaseFirestore>();
  Future<Result> _try(Future<Result> Function() callback) async {
    try {
      final result = await callback();
      return result;
    } on FirebaseException catch (e) {
      return Result(error: GeneralError(e.message.toString()));
    } catch (e) {
      print("error is ${e.toString()}");
      return const Result(error: GeneralError("Something went wrong"));
    }
  }

  // Future<Result> createChatRoom()async{
  Future<Result> updateChatRoomFinalMessage(
      String chatRoomId, Message message) {
    return _try(() async {
      final user = _authService.currentUser;
      if (user == null) {
        return const Result(error: GeneralError("User not found"));
      }
      final result = await db.collection("ChatRoom").doc(chatRoomId).update({
        "finalMessage": message.data,
        "finalMessageTime": message.sendingTime
      });

      return const Result();
    });
  }

  // }
  Future<Result> createChatRoom(
    ChatRoomParams room,
  ) {
    return _try(() async {
      final payload = room.toCreate();
      return _try(() async {
        final user = _authService.currentUser;
        if (user == null) {
          return const Result(error: GeneralError("User not found"));
        }

        final doc = db.collection("ChatRoom").doc();

        payload.addEntries({MapEntry("id", doc.id)});
        print("create payload $payload");
        await doc.set(payload, SetOptions(merge: true));
        return Result(data: payload);
      });
    });
  }

  Future<Result> deleteChatRoom(ChatRoom room) async {
    return _try(() async {
      final result = await db.collection("ChatRoom").doc(room.id).delete();
      final message = await db
          .collection("Message")
          .where("chatRoomId", isEqualTo: room.id)
          .get();
      logger.i("this is message ${message.docs.length}");
      for (var item in message.docs) {
        await db.collection("Message").doc(item.id).delete();
      }
      return const Result(data: null);
    });
  }

  Future<Result> checkChatRoomCreateifNotExist(
      ContactUser other, ChatRoomParams chatRoomParams) async {
    logger.i("checkChatRoomCreateifNotExist");
    logger.i("check try");
    final user = _authService.currentUser;
    if (user == null) {
      return const Result(error: GeneralError("User not found"));
    }

    final doc = db.collection("ChatRoom");
    final checkExist = await doc
        .where("fromUserId", isEqualTo: user.uid)
        .where("toUserId", isEqualTo: other.uid)
        .get();
    if (checkExist.docs.isEmpty) {
      final result = await doc
          .where("fromUserId", isEqualTo: other.uid)
          .where("toUserId", isEqualTo: user.uid)
          .get();
      if (result.docs.isEmpty) {
        final newroom = await createChatRoom(chatRoomParams);
        return Result(data: newroom.data);
      } else {
        return Result(data: result.docs.first.data());
      }
    }
    return Result(data: checkExist.docs.first.data());
  }

  Future<Result> getListOfChatRoom() async {
    return _try(() async {
      final user = _authService.currentUser;
      if (user == null) {
        return const Result(error: GeneralError("User not found"));
      }
      final doc = db.collection("ChatRoom");
      // final notext = await doc
      //     .where("member", arrayContains: user.uid)
      //     .orderBy("updated_At", descending: true)
      //     .get();

      // for (var rooms in notext.docs) {
      //   final messages = await db
      //       .collection("Message")
      //       .where("chatRoomId", isEqualTo: rooms.id)
      //       .get();
      //   final message = Message.fromJson(messages.docs.first.data());
      //   logger.i("this is messages $messages");

      // }

      List<ChatRoom> rooms = [];

      final results = await doc
          .where("member", arrayContains: user.uid)
          .orderBy("finalMessageTime", descending: true)
          .get();
      for (var data in results.docs) {
        final chatrooms = ChatRoom.fromJson(data);
        rooms.add(chatrooms);
      }

      return Result(data: rooms);
    });
  }

  Stream chatrooms() {
    final doc = db.collection("ChatRoom");
    final result =
        doc.where("member", arrayContains: _authService.currentUser?.uid);
    return result.snapshots();
  }

  void contactListener(void Function(ChatRoom) messages) async {
    final doc = db.collection("ChatRoom");
    final result = doc
        .where("member", arrayContains: _authService.currentUser?.uid)
        .orderBy("updated_At", descending: true);
    chatRoomStream = result.snapshots().listen((event) {
      print("event is ${event.docs}");
      if (event.docs.isNotEmpty) {
        final message = ChatRoom.fromJson(event.docs.first.data());
        print("stream User ${message.id}");
        messages(message);
      }
    });
  }
}
