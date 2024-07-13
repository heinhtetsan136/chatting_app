import 'package:blca_project_app/controller/chat_room/chat_room_sendMessage_bloc.dart/chat_room_bloc.dart';
import 'package:blca_project_app/logger.dart';
import 'package:blca_project_app/view/contact_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MessagingScreen extends StatelessWidget {
  const MessagingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final chatroomBloc = context.read<ChatRoomBloc>();
    return Scaffold(
        body: StreamBuilder(
            key: UniqueKey(),
            stream: chatroomBloc.roomStream.stream,
            builder: (_, snap) {
              final state = snap.data;
              logger.i(state);
              if (snap.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snap.data == null) {
                return const Center(
                  child: Text("No Data"),
                );
              }
              return ListView.builder(
                itemBuilder: (_, i) {
                  logger.i("object is ${state?[i].toUserName}");
                  print("object is ${state?[i].toUserName}");
                  return ChatRoom(
                      name: state?[i].toUserName ?? "",
                      message: "sssssss",
                      onTap: () {});
                },
                itemCount: state?.length ?? 0,
              );
            }));
  }
}
