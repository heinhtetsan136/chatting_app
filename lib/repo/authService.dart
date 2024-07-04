import 'dart:async';

import 'package:blca_project_app/model/error.dart';
import 'package:blca_project_app/model/result.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth;
  User? currentUser;
  Stream<User?> get authState => _authStateController.stream;
  final StreamController<User?> _authStateController =
      StreamController<User?>.broadcast();
  StreamSubscription? _authStateStreamSubscription;
  AuthService() : _auth = FirebaseAuth.instance {
    _authStateStreamSubscription = _auth.userChanges().listen((user) {
      _authStateController.sink.add(user);
      currentUser = user;
    });
  }
  Future<Result> signOut() async {
    return _try(() async {
      final result = _auth.signOut();
      return Result(data: result);
    });
  }

  Future<Result> _try(Future<Result> Function() callback) async {
    try {
      final result = await callback();
      return result;
    } on FirebaseAuthException catch (e) {
      return Result(error: GeneralError(e.toString()));
    } catch (e) {
      return const Result(error: GeneralError("Unknow Error"));
    }
  }

  Future<Result> signIn(String email, String password) async {
    return _try(() async {
      final UserCredential user = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return Result(data: user);
    });
  }

  Future<Result> login(String email, String password) async {
    return _try(() async {
      final UserCredential user = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return Result(data: user);
    });
  }

  void dispose() {
    _authStateController.close();
    _authStateStreamSubscription?.cancel();
  }
}
