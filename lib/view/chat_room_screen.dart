import 'package:blca_project_app/controller/chat_room/chat_room_sendMessage_bloc.dart/chat_room_bloc.dart';
import 'package:blca_project_app/controller/chat_room/chat_room_sendMessage_bloc.dart/chat_room_event.dart';
import 'package:blca_project_app/controller/chat_room/chat_room_sendMessage_bloc.dart/chat_room_state.dart';
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
      body: BlocBuilder<ChatRoomBloc, ChatRoomBaseState>(builder: (_, state) {
        final post = state.message;
        if (state is ChatRoomLoadingState) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (post.isEmpty) {
          return Center(
              child: TextButton(
            onPressed: () {
              chatroomBloc.add(RefreshChatRoomEvent());
            },
            child: const Text("No Data"),
          ));
        }

        return RefreshIndicator(
          onRefresh: () async {
            chatroomBloc.add(RefreshChatRoomEvent());
          },
          child: ListView.builder(
            itemBuilder: (_, i) {
              logger.i("object is ${state.message[i].toUserName}");
              print("object is ${state.message[i].toUserName}");
              return ChatRoom(
                  name: state.message[i].toUserName ?? "",
                  message: "sssssss",
                  onTap: () {});
            },
            itemCount: state.message.length,
          ),
        );
      }),
    );
  }
}
