import 'dart:async';

import 'package:blca_project_app/injection.dart';
import 'package:blca_project_app/model/error.dart';
import 'package:blca_project_app/model/result.dart';
import 'package:blca_project_app/repo/authService.dart';
import 'package:blca_project_app/repo/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FireStoreService {
  final AuthService _authService = Injection.get<AuthService>();

  final FirebaseFirestore db = Injection.get<FirebaseFirestore>();
  StreamSubscription? contactStream;
  dispose() {
    contactStream?.cancel();
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

  Future<Result> getUser() async {
    return _try(() async {
      final user = _authService.currentUser;
      if (user == null) {
        return const Result(error: GeneralError("User not found"));
      }
      final doc = db.collection("users");
      final snapshot = await doc.get();
      print("snapshot is $snapshot.docs");
      final List<ContactUser> contactUser = [];
      for (var element in snapshot.docs) {
        final user = ContactUser.fromJson(element.data());
        if (user.uid == user.uid) {
          contactUser.add(user);
        }
      }
      return Result(data: contactUser);
    });
  }

  Future<Result> createUser(UserCredential user) async {
    return _try(() async {
      final doc = db.collection("users").doc(user.user!.uid);
      final ContactUser contactUser = ContactUser(
          uid: user.user!.uid,
          displayName: user.user!.displayName,
          email: user.user!.email!,
          photoURL: user.user!.photoURL,
          phoneNumber: user.user!.phoneNumber);
      print("contactUser is $contactUser");
      await doc.set(
        contactUser.toJson(),
        SetOptions(merge: true),
      );
      return Result(
        data: contactUser,
      );
    });
  }

  void contactListener(void Function(ContactUser) contact) {
    contactStream = db.collection("users").snapshots().listen((event) {
      final user = ContactUser.fromJson(event.docs.first.data());
      contact(user);
    });
  }
}
