import 'package:blca_project_app/controller/home_controller/home_controller_bloc.dart';
import 'package:blca_project_app/controller/home_controller/home_controller_event.dart';
import 'package:blca_project_app/controller/home_controller/home_controller_state.dart';
import 'package:blca_project_app/route/route.dart';
import 'package:blca_project_app/view/chat_room_screen.dart';
import 'package:blca_project_app/view/contact_screen.dart';
import 'package:blca_project_app/view/homeScreen/post_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:starlight_utils/starlight_utils.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final homePageBloc = context.read<HomePageBloc>();
    return BlocListener<HomePageBloc, HomeBlocBaseState>(
      listener: (_, state) {
        print("state is $state");
        if (state is HomeLogout) {
          StarlightUtils.pushReplacementNamed(RouteNames.loginPage);
        }
      },
      child: Scaffold(
          appBar: AppBar(
            actions: [
              IconButton(
                  onPressed: () {
                    StarlightUtils.pushNamed(RouteNames.settingPage);
                  },
                  icon: const Icon(Icons.settings))
            ],
          ),
          drawer: Drawer(
            child: ListView(
              children: [
                const DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                  ),
                  child: Text("Drawer Header"),
                ),
                ListTile(
                  title: const Text("Logout"),
                  onTap: () {
                    homePageBloc.add(const SignoutEvent());
                  },
                )
              ],
            ),
          ),
          resizeToAvoidBottomInset: false,
          body: PageView.builder(
            controller: homePageBloc.controller,
            itemBuilder: (_, i) {
              return [
                const MessagingScreen(),
                const HomePage(),
                const PostScreen(),
              ][i];
            },
            itemCount: 3,
          ),
          bottomNavigationBar:
              BlocBuilder<HomePageBloc, HomeBlocBaseState>(builder: (_, state) {
            print("state is $state");
            if (state is HomeBlocNavigationState) {
              return BottomNavigationBar(
                  currentIndex: state.index,
                  onTap: (i) {
                    homePageBloc.add(homePageBloc.activate(i));
                  },
                  items: const [
                    BottomNavigationBarItem(
                        icon: Icon(Icons.chat), label: "Chat"),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.contact_emergency), label: "Contact"),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.settings), label: "Post"),
                  ]);
            }
            return const SizedBox();
          })),
    );
  }
}
