import 'package:blca_project_app/controller/home_controller/home_controller_bloc.dart';
import 'package:blca_project_app/view/homeScreen/post_screen.dart';
import 'package:blca_project_app/view/message_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final homePageBloc = context.read<HomePageBloc>();
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: PageView.builder(
          controller: homePageBloc.controller,
          itemBuilder: (_, i) {
            return [
              const HomePage(),
              const HomePage(),
              const PostScreen(),
            ][i];
          },
          itemCount: 3,
        ),
        bottomNavigationBar:
            BlocBuilder<HomePageBloc, int>(builder: (_, state) {
          print("state is $state");
          return BottomNavigationBar(
              currentIndex: state,
              onTap: (i) {
                homePageBloc.add(homePageBloc.activate(i));
              },
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.chat), label: "Chat"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.contact_emergency), label: "Contact"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.settings), label: "Post"),
              ]);
        }));
  }
}
