import 'package:blca_project_app/controller/chat_room/chat_room_list_controller/chat_room_list_bloc.dart';
import 'package:blca_project_app/controller/chat_room/chat_room_list_controller/chat_room_list_event.dart';
import 'package:blca_project_app/controller/chat_room/chat_room_list_controller/chat_room_list_state.dart';
import 'package:blca_project_app/injection.dart';
import 'package:blca_project_app/logger.dart';
import 'package:blca_project_app/repo/authService.dart';
import 'package:blca_project_app/route/route.dart';
import 'package:blca_project_app/view/contact_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:starlight_utils/starlight_utils.dart';

class ChatRoomListScreen extends StatelessWidget {
  const ChatRoomListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final chatroomBloc = context.read<ChatRoomListBloc>();
    return Scaffold(
      body:
          BlocBuilder<ChatRoomListBloc, ChatRoomBaseState>(builder: (_, state) {
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
              final members =
                  state.message[i].member.map((e) => e.toString()).toList();
              logger.i("object is ${state.message[i].toUserName}");
              print("object is ${state.message[i].toUserName}");
              return ChatRoom(
                  name: members[0] ==
                          Injection.get<AuthService>().currentUser!.uid
                      ? members[1]
                      : members[0],
                  message: "sssssss",
                  onTap: () {
                    StarlightUtils.pushNamed(RouteNames.messaging,
                        arguments: state.message[i]);
                  });
            },
            itemCount: state.message.length,
          ),
        );
      }),
    );
  }
}
