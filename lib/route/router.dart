import 'package:blca_project_app/controller/home_controller/home_controller_bloc.dart';
import 'package:blca_project_app/controller/register/register_state.dart';
import 'package:blca_project_app/controller/register/resgister_bloc.dart';
import 'package:blca_project_app/injection.dart';
import 'package:blca_project_app/repo/authService.dart';
import 'package:blca_project_app/route/route.dart';
import 'package:blca_project_app/view/auth/login_page.dart';
import 'package:blca_project_app/view/auth/sign_up_page.dart';
import 'package:blca_project_app/view/homeScreen/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Route? router(RouteSettings settings) {
  final String incomingRoute = settings.name ?? "/";
  switch (incomingRoute) {
    case RouteNames.loginPage:
      return _protectedRoute(incomingRoute, const LoginPage(), settings);
    case RouteNames.signUpPage:
      return _route(
          BlocProvider(
              create: (_) => ResgisterBloc(const RegisterInitialState()),
              child: const SignUpPage()),
          settings);

    case RouteNames.homePage:
      return _protectedRoute(
          incomingRoute,
          MultiBlocProvider(
              providers: [BlocProvider(create: (_) => HomePageBloc())],
              child: const HomeScreen()),
          settings);
    default:
      // return _route(const LoginPage(), settings);
      return _protectedRoute(
          incomingRoute,
          MultiBlocProvider(
              providers: [BlocProvider(create: (_) => HomePageBloc())],
              child: const HomeScreen()),
          settings);
  }
}

List<String> _protectedRoutePath = ["/"];
Route? _protectedRoute(String path, Widget child, RouteSettings settings) {
  if (Injection.get<AuthService>().currentUser == null &&
      _protectedRoutePath.contains(path)) {
    return _route(const LoginPage(), settings);
  }
  return _route(child, settings);
}

Route? _route(Widget child, RouteSettings settings) {
  return MaterialPageRoute(
      builder: (_) {
        return child;
      },
      settings: settings);
}
