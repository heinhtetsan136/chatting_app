import 'dart:async';
import 'dart:io';

import 'package:blca_project_app/injection.dart';
import 'package:blca_project_app/model/error.dart';
import 'package:blca_project_app/model/result.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class AuthService {
  final FirebaseAuth _auth;
  final ImagePicker _imagePicker;
  final FirebaseStorage _storage;

  Timer? _timer;
  final StreamController<User?> _authStateController =
      StreamController.broadcast();
  StreamSubscription? _authStateStreamSubscription;
  AuthService()
      : _storage = Injection.get<FirebaseStorage>(),
        _imagePicker = Injection.get<ImagePicker>(),
        _auth = FirebaseAuth.instance {
    _auth.currentUser?.reload();
    _authStateStreamSubscription = _auth.userChanges().listen((user) {
      _authStateController.sink.add(user);
      currentUser = user;
      print("currentUser is $currentUser");
      print("AuthState: $user");

      print("AuthState: $user");
      if (user == null) {
        _timer?.cancel();
        _timer = null;
        print("Timer is Canel by user stream");
      }
    });
  }
  User? currentUser;
  Stream<User?> authState() {
    print("object is ${_authStateController.stream}");
    return _auth.userChanges();
  }

  Future<Result> signOut() async {
    return _try(() async {
      final result = _auth.signOut();
      return Result(data: result);
    });
  }

  Future<Result> updatePassword(String password, String oldPassword) async {
    return _try(() async {
      final user = currentUser;
      if (user == null) {
        return const Result(error: GeneralError("User not found"));
      }
      final value = await currentUser!
          .reauthenticateWithCredential(EmailAuthProvider.credential(
        email: user.email!,
        password: oldPassword,
      ));
      await value.user!.updatePassword(password);
      await value.user!.reload();
      return Result(data: user);
    });
  }

  Future<Result> updateUserName(String name) async {
    return _try(() async {
      final user = currentUser;
      if (user == null) {
        return const Result(error: GeneralError("User not found"));
      }

      await user.updateDisplayName(name);
      return Result(data: user);
    });
  }

  Future<Result> _try(Future<Result> Function() callback) async {
    try {
      final result = await callback();
      return result;
    } on FirebaseAuthException catch (e) {
      return Result(error: GeneralError(e.message.toString()));
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

  Future<Result> uploadImage() async {
    final user = currentUser;
    if (user == null) {
      return const Result(error: GeneralError("User not found"));
    }
    final image = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (image == null) {
      return const Result(error: GeneralError("No image selected"));
    }
    final prev = user.photoURL;
    if (prev?.startsWith("users/") == true) {
      await _storage.ref(prev!).delete();
    }
    final ref = _storage.ref().child("user_profile/${user.uid}");
    final profilePath = "users/${user.uid}_${DateTime.now().toIso8601String()}";
    await _storage.ref(profilePath).putFile(File(profilePath));
    return Result(data: ref.getDownloadURL());
  }

  Future<Result> updateEmail(String newEmail, String password) async {
    return _try(() async {
      final user = currentUser;

      if (user == null) {
        return const Result(error: GeneralError("User not found"));
      }
      await user.reload();
      final value = await currentUser!
          .reauthenticateWithCredential(EmailAuthProvider.credential(
        email: user.email ?? "",
        password: password,
      ));

      await value.user!.verifyBeforeUpdateEmail(newEmail);
      await value.user!.reload();
      if (currentUser == null) {
        return Result(data: user);
      }
      _timer = Timer.periodic(const Duration(seconds: 10), (timer) async {
        print("timer user Reload ${timer.tick}");
        print("timer user $currentUser");

        print("timer reload");
        if (currentUser != null) {
          print("timer user not null");
          await _auth.currentUser!.reload();
          return;
        }
        print("timer user null");
        _timer?.cancel();
        _timer = null;
      });
      await Future.delayed(const Duration(seconds: 100), () {
        if (_timer == null) {
          print("timer is null");
          return Result(data: user);
        }
        print("timer is cancel by waiting time");
        _timer?.cancel();
        _timer = null;
      });

      print("timer not null");

      return const Result(error: GeneralError("Comfirm time over"));
    });
  }

  Future<Result> sendReseltLink(String email) async {
    return _try(() async {
      final result = await _auth.sendPasswordResetEmail(email: email);
      return const Result(data: User);
    });
  }

  void dispose() {
    _timer?.cancel();
    _authStateController.close();
    _authStateStreamSubscription?.cancel();
  }
}
