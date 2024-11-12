import 'package:blca_project_app/firebase_options.dart';
import 'package:blca_project_app/repo/MessageingService.dart';
import 'package:blca_project_app/repo/agoraService/agoraService.dart';
import 'package:blca_project_app/repo/authService.dart';
import 'package:blca_project_app/repo/chatroom_service.dart';
import 'package:blca_project_app/repo/firestoreService.dart';
import 'package:blca_project_app/repo/ui_video_call_Service.dart/ui_video_call_Service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

final Injection = GetIt.instance;
Future<void> setUp() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
  Injection.registerLazySingleton(() => sharedPreferences);
  await FirebaseAppCheck.instance.activate(
    // You can also use a `ReCaptchaEnterpriseProvider` provider instance as an
    // argument for `webProvider`
    webProvider: ReCaptchaV3Provider('recaptcha-v3-site-key'),
    // Default provider for Android is the Play Integrity provider. You can use the "AndroidProvider" enum to choose
    // your preferred provider. Choose from:
    // 1. Debug provider
    // 2. Safety Net provider
    // 3. Play Integrity provider
    androidProvider: AndroidProvider.debug,
    // Default provider for iOS/macOS is the Device Check provider. You can use the "AppleProvider" enum to choose
    // your preferred provider. Choose from:
    // 1. Debug provider
    // 2. Device Check provider
    // 3. App Attest provider
    // 4. App Attest provider with fallback to Device Check provider (App Attest provider is only available on iOS 14.0+, macOS 14.0+)
    appleProvider: AppleProvider.appAttest,
  );

  Injection.registerLazySingleton(() => ImagePicker());
  Injection.registerLazySingleton(() => FirebaseFirestore.instance);
  Injection.registerLazySingleton(() => FirebaseStorage.instance);
  Injection.registerSingleton(AuthService(),
      dispose: (instance) => instance.dispose());

  Injection.registerLazySingleton(() => ContactUserService());
  Injection.registerLazySingleton(() => ChatRoomService());
  Injection.registerLazySingleton(() => MessagingService());
  Injection.registerLazySingleton(() => VideoCallService());
  final agoraService = await AgoraService.instance();
  Injection.registerLazySingleton(() => agoraService);
}
