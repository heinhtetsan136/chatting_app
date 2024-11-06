import 'package:blca_project_app/controller/chat_room/chat_room_create_controller/chat_room_create_bloc.dart';
import 'package:blca_project_app/controller/chat_room/chat_room_create_controller/chat_room_create_state.dart';
import 'package:blca_project_app/controller/chat_room/chat_room_list_controller/chat_room_list_bloc.dart';
import 'package:blca_project_app/controller/chatting/chatting_bloc.dart';
import 'package:blca_project_app/controller/chatting/chatting_state.dart';
import 'package:blca_project_app/controller/chatting/send_data/send_data_bloc.dart';
import 'package:blca_project_app/controller/contact_controller/controller_bloc.dart';
import 'package:blca_project_app/controller/home_controller/home_controller_bloc.dart';
import 'package:blca_project_app/controller/login/login_bloc.dart';
import 'package:blca_project_app/controller/profile_setting/profile_setting_bloc.dart';
import 'package:blca_project_app/controller/register/register_state.dart';
import 'package:blca_project_app/controller/register/resgister_bloc.dart';
import 'package:blca_project_app/injection.dart';
import 'package:blca_project_app/repo/authService.dart';
import 'package:blca_project_app/repo/chatRoom_model.dart';
import 'package:blca_project_app/route/route.dart';
import 'package:blca_project_app/view/auth/login_page.dart';
import 'package:blca_project_app/view/auth/sign_up_page.dart';
import 'package:blca_project_app/view/call/call.dart';
import 'package:blca_project_app/view/homeScreen/home.dart';
import 'package:blca_project_app/view/messaging_screen.dart';
import 'package:blca_project_app/view/search_screen.dart';
import 'package:blca_project_app/view/setting/profile_page.dart';
import 'package:blca_project_app/view/setting/setting_page.dart';
import 'package:blca_project_app/view/setting/update_user_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Route? router(RouteSettings settings) {
  final String incomingRoute = settings.name ?? "/";
  switch (incomingRoute) {
    case RouteNames.loginPage:
      return _protectedRoute(
          incomingRoute,
          BlocProvider(create: (_) => LoginBloc(), child: const LoginPage()),
          settings);
    case RouteNames.messaging:
      final values = settings.arguments;
      if (values is! ChatRoom) {
        return _route(
            const Scaffold(
                body: Center(
              child: Text("Page not found"),
            )),
            settings);
      }
      return _protectedRoute(
          incomingRoute,
          MultiBlocProvider(
              providers: [
                BlocProvider(
                    create: (_) =>
                        ChattingBloc(ChattingInitialState(const []), values)),
                BlocProvider(create: (_) => SendDataBloc(values))
              ],
              child: MessagingScreen(
                chatRoom: values,
              )),
          settings);
    case RouteNames.signUpPage:
      return _route(
          BlocProvider(
              create: (_) => ResgisterBloc(const RegisterInitialState()),
              child: const SignUpPage()),
          settings);
    case RouteNames.search:
      return _protectedRoute(incomingRoute, const SearchScreen(), settings);
    case RouteNames.profile:
      return _protectedRoute(incomingRoute, const ProfilePage(), settings);
    case RouteNames.homePage:
      return _protectedRoute(
          incomingRoute,
          MultiBlocProvider(providers: [
            BlocProvider(create: (_) => ChatRoomListBloc()),
            BlocProvider(
                create: (_) =>
                    ChatRoomCreateBloc(const ChatRoomCreateInitialState())),
            BlocProvider(create: (_) => HomePageBloc()),
            BlocProvider(create: (_) => ContactBloc()),
          ], child: const HomeScreen()),
          settings);
    case RouteNames.updatePassword:
      return _protectedRoute(
          incomingRoute,
          BlocProvider(
              create: (_) => ProfileSettingBloc(),
              child: const UpdateUserInfo(
                isChangeEmail: false,
              )),
          settings);
    case RouteNames.updateEmail:
      return _protectedRoute(
          incomingRoute,
          BlocProvider(
              create: (_) => ProfileSettingBloc(),
              child: const UpdateUserInfo(
                isChangeEmail: true,
              )),
          settings);
    case RouteNames.updateUserName:
      return _protectedRoute(
          incomingRoute,
          BlocProvider(
              create: (_) => ProfileSettingBloc(),
              child: const UpdateUserInfo()),
          settings);
    case RouteNames.call:
      return _protectedRoute(incomingRoute, const Call(), settings);
    case RouteNames.settingPage:
      return _protectedRoute(incomingRoute, const SettingPage(), settings);
    default:
      // return _route(const LoginPage(), settings);
      return _route(
          const Scaffold(
              body: Center(
            child: Text("Page not found"),
          )),
          settings);
  }
}

List<String> _protectedRoutePath = ["/"];
Route? _protectedRoute(String path, Widget child, RouteSettings settings) {
  print("route user is ${Injection.get<AuthService>().currentUser}");
  return _route(
    Injection<AuthService>().currentUser == null
        ? BlocProvider(
            create: (_) => LoginBloc(),
            child: const LoginPage(),
          )
        : child,
    settings,
  );
}

Route? _route(Widget child, RouteSettings settings) {
  return MaterialPageRoute(
      builder: (_) {
        return child;
      },
      settings: settings);
}
