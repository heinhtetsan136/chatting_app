import 'package:blca_project_app/controller/theme/theme_cubit.dart';
import 'package:blca_project_app/controller/videoCall/db_controller/video_call_db_blco.dart';
import 'package:blca_project_app/injection.dart';
import 'package:blca_project_app/route/route.dart';
import 'package:blca_project_app/route/router.dart';
import 'package:blca_project_app/theme/light_theme.dart';
import 'package:blca_project_app/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:starlight_utils/starlight_utils.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setUp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final AppStandardTheme appLightTheme = AppLightTheme();
    final AppStandardTheme appDarkTheme = AppDarkTheme();
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => VideoCallDbBlco(),
        ),
        BlocProvider<ThemeCubit>(
          create: (context) => ThemeCubit(ThemeMode.light),
        )
      ],
      child: Builder(builder: (context) {
        return BlocBuilder<ThemeCubit, ThemeMode>(builder: (context, state) {
          return MaterialApp(
            navigatorKey: StarlightUtils.navigatorKey,
            initialRoute: RouteNames.homePage,
            onGenerateRoute: router,
            title: 'Flutter Demo',
            darkTheme: appDarkTheme.theme,
            theme: appLightTheme.theme,
            themeMode: state,
          );
        });
      }),
    );
  }
}
