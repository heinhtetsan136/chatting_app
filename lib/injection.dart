import 'package:blca_project_app/firebase_options.dart';
import 'package:blca_project_app/repo/authService.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';

final Injection = GetIt.instance;
Future<void> setUp() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Injection.registerSingleton(AuthService(),
      dispose: (instance) => instance.dispose());
}
