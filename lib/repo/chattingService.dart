import 'dart:async';

import 'package:blca_project_app/injection.dart';
import 'package:blca_project_app/logger.dart';
import 'package:blca_project_app/model/error.dart';
import 'package:blca_project_app/model/result.dart';
import 'package:blca_project_app/repo/authService.dart';
import 'package:blca_project_app/repo/chatroom_service.dart';
import 'package:blca_project_app/repo/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class MessagingService {
  final AuthService _authService = Injection.get<AuthService>();
  final ChatRoomService _chatRoomService = Injection.get<ChatRoomService>();
  final FirebaseFirestore _db = Injection.get<FirebaseFirestore>();
  final FirebaseStorage _storage = Injection.get<FirebaseStorage>();

  Future<Result> getMessages(String chatRoomId, [int limit = 20]) async {
    return _try(() async {
      final user = _authService.currentUser;
      if (user == null) {
        return const Result(error: GeneralError("Authentication error"));
      }
      logger.i("getMessage $chatRoomId");
      final doc = _db.collection("Message");
      final result = await doc
          .where("chatRoomId", isEqualTo: chatRoomId)
          .orderBy("sendingTime", descending: true)
          .limit(limit)
          .get();
      final List<Message> messages = [];
      for (var item in result.docs) {
        final message = Message.fromJson(item.data());
        messages.add(message);
      }
      logger.i("getMessage ${messages.length}");
      return Result(data: messages);
    });
  }

  Future<Result> sendMessage(MessageParams message) async {
    return _try(() async {
      final payload = message.toCreate();
      final doc = _db.collection("Message").doc();
      payload.addEntries({MapEntry("id", doc.id)});
      payload.addEntries({MapEntry("sendingTime", Timestamp.now())});
      await doc.set(payload, SetOptions(merge: true));
      _chatRoomService.updateChatRoomFinalMessage(
          message.chatRoomId,
          Message(
              id: doc.id,
              chatRoomId: message.chatRoomId,
              fromUser: message.fromUser,
              data: message.data,
              sendingTime: Timestamp.now(),
              isText: message.isText));
      return Result(data: payload);
    });
  }

  Future<Result> updateMessage(String messageId, String editedText) async {
    return _try(() async {
      final result = await _db.collection("Message").doc(messageId).get();
      if (result.data()?.isNotEmpty == false) {
        return const Result(error: GeneralError("Something Wrong"));
      }
      final Message oldMessage = Message.fromJson(result.data());

      final Message newMessage = Message(
          id: oldMessage.id,
          chatRoomId: oldMessage.chatRoomId,
          fromUser: oldMessage.fromUser,
          data: editedText,
          sendingTime: oldMessage.sendingTime);
      await _db.collection("Message").doc(messageId).set(newMessage.toJson());
      return Result(data: newMessage.toJson());
    });
  }

  Future<Result> deleteMessage(Message message) async {
    return _try(() async {
      if (message.isText == false) {
        print("message is photo");
        final result = await _storage.refFromURL(message.data!).delete();
      }
      await _db.collection("Message").doc(message.id).delete();

      return const Result(data: ());
    });
  }

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

  int previousLength = 0;
  StreamSubscription? messagesstream;
  void contactListener(
      void Function(Message) messages, String chatRoomId) async {
    final doc = _db.collection("Message");
    final result = doc
        .where("chatRoomId", isEqualTo: chatRoomId)
        .orderBy("sendingTime", descending: true);

    messagesstream = result.snapshots().listen((event) {
      print("event is ${event.docs}");
      if (event.docs.isNotEmpty) {
        if (event.docs.length < previousLength) {
          return;
        }
        previousLength = event.docs.length;

        final message = Message.fromJson(event.docs.first.data());
        print("stream User ${message.id}");
        messages(message);
      }
    });
  }
}
