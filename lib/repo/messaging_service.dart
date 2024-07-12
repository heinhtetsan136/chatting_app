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

  Future<Result> SendMessage(ChatRoomParams room, String message) async {
    final payload = room.toCreate();

    return _try(() async {
      final user = _authService.currentUser;
      if (user == null) {
        return const Result(error: GeneralError("User not found"));
      }
      List<String> keyFormatter = [room.toUserId, room.fromUserId];
      keyFormatter.sort();
      final String key = keyFormatter.join("_");
      print("key $key");
      final doc = _db.collection("chatRoom").doc(key);
      payload.addEntries({MapEntry("id", doc.id)});
      final snap = await doc.get();
      if (snap.exists) {
        print("exist is true");
        await doc
            .collection("messages")
            .add({"message": message, "fromUserId": user.uid});
        return const Result(data: ());
      }
      await doc.set(payload, SetOptions(merge: true));
      await doc
          .collection("messages")
          .add({"message": message, "fromUserId": user.uid});
      return const Result(data: ());
    });
  }

  Future<Result> getMessage(ContactUser other) async {
    return _try(() async {
      final user = _authService.currentUser;
      if (user == null) {
        return const Result(error: GeneralError("User not found"));
      }
      List<String> keyFormatter = [other.uid, user.uid];
      keyFormatter.sort();
      final String key = keyFormatter.join("_");
      print("get Key $key");
      final db = _db.collection("chatRoom").doc(key);
      final doc = db.collection("messages").where("id", isEqualTo: key);
      final snapshot = await doc.get();
      print("snapshot is ${snapshot.docs}docs");
      final List<ChatRoom> contactUser = [];
      for (var element in snapshot.docs) {
        final message = ChatRoom.fromJson(element.data());
        contactUser.add(message);
      }
      print("contactUser is $contactUser");
      return Result(data: contactUser);
    });
  }

  void contactListener(void Function(ChatRoom) message, ContactUser other) {
    List<String> keyFormatter = [other.uid, _authService.currentUser!.uid];
    keyFormatter.sort();
    final String key = keyFormatter.join("_");
    _messagestream = _db
        .collection("chatRoom")
        .doc(key)
        .collection("messages")
        .snapshots()
        .listen((event) {
      print("event is ${event.docs}");
      if (event.docs.isNotEmpty) {
        final user = ChatRoom.fromJson(event.docs.first.data());
        print("stream User $user");
        message(user);
      }
    });
  }

  dispose() {
    _messagestream?.cancel();
  }
}
