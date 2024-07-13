import 'dart:async';

import 'package:blca_project_app/injection.dart';
import 'package:blca_project_app/logger.dart';
import 'package:blca_project_app/model/error.dart';
import 'package:blca_project_app/model/result.dart';
import 'package:blca_project_app/repo/authService.dart';
import 'package:blca_project_app/repo/chatRoom_model.dart';
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

  // }
  Future<Result> createChatRoom(
    ChatRoomParams room,
  ) async {
    final payload = room.toCreate();
    return _try(() async {
      final user = _authService.currentUser;
      if (user == null) {
        return const Result(error: GeneralError("User not found"));
      }

      final doc = db.collection("ChatRoom").doc();
      final result = await getChatRoom();
      payload.addEntries({MapEntry("id", doc.id)});
      print("create payload $payload");
      await doc.set(payload, SetOptions(merge: true));
      return Result(data: payload);
    });
  }

  Future<Result> checkChatRoom(ContactUser other) async {
    return _try(() async {
      final user = _authService.currentUser;
      if (user == null) {
        return const Result(error: GeneralError("User not found"));
      }

      final doc = db.collection("ChatRoom");
      final checkOne = await doc
          .where("fromUserId", isEqualTo: user.uid)
          .where("toUserId", isEqualTo: other.uid)
          .get();
      if (checkOne.docs.isEmpty) {
        final result = await doc
            .where("fromUserId", isEqualTo: other.uid)
            .where("toUserId", isEqualTo: user.uid)
            .get();
        if (result.docs.isEmpty) {
          return const Result(data: false);
        } else {
          return const Result(data: true);
        }
      }
      return const Result(data: true); // chat room has been created
    });
  }

  Future<Result> getChatRoom() async {
    return _try(() async {
      final user = _authService.currentUser;
      if (user == null) {
        return const Result(error: GeneralError("User not found"));
      }
      final doc = db.collection("ChatRoom");
      final result = await doc.where("member", arrayContains: user.uid).get();
      List<ChatRoom> rooms = [];
      for (var room in result.docs) {
        final chatroom = ChatRoom.fromJson(room);
        logger.i("stream User $chatroom");
        rooms.add(chatroom);
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
    final result =
        doc.where("member", arrayContains: _authService.currentUser?.uid);
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
