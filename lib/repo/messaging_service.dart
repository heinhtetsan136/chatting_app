import 'dart:async';

import 'package:blca_project_app/injection.dart';
import 'package:blca_project_app/model/error.dart';
import 'package:blca_project_app/model/result.dart';
import 'package:blca_project_app/repo/authService.dart';
import 'package:blca_project_app/repo/chatRoom_model.dart';
import 'package:blca_project_app/repo/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MessagingService {
  StreamSubscription? _messagestream;
  final AuthService _authService = Injection.get<AuthService>();
  final FirebaseFirestore _db = Injection.get<FirebaseFirestore>();
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

  Future<Result> SendMessage(ChatRoomParams message) async {
    final payload = message.toCreate();

    return _try(() async {
      final user = _authService.currentUser;
      if (user == null) {
        return const Result(error: GeneralError("User not found"));
      }
      final doc = _db.collection("messages").doc(message.toUserId);
      payload.addEntries({MapEntry("id", doc.id)});

      await doc.set(payload);
      return const Result(data: ());
    });
  }

  Future<Result> getMessage(ContactUser other) async {
    return _try(() async {
      final user = _authService.currentUser;
      if (user == null) {
        return const Result(error: GeneralError("User not found"));
      }
      final doc = _db
          .collection("messages")
          .where("toUserId", isEqualTo: user.uid)
          .where("fromUserId", isEqualTo: other.uid);
      final snapshot = await doc.get();
      print("snapshot is $snapshot.docs");
      final List<ChatRoom> contactUser = [];
      for (var element in snapshot.docs) {
        final user = ChatRoom.fromJson(element.data());
        contactUser.add(user);
      }
      return Result(data: contactUser);
    });
  }

  void contactListener(void Function(ChatRoom) message) {
    _messagestream = _db.collection("messages").snapshots().listen((event) {
      final user = ChatRoom.fromJson(event.docs.first.data());
      message(user);
    });
  }

  dispose() {
    _messagestream?.cancel();
  }
}
