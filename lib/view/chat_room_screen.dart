import 'package:blca_project_app/controller/chat_room/chat_room_create_controller/chat_room_create_bloc.dart';
import 'package:blca_project_app/controller/chat_room/chat_room_create_controller/chat_room_create_event.dart';
import 'package:blca_project_app/controller/chat_room/chat_room_create_controller/chat_room_create_state.dart';
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
    List<String> months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec"
    ];
    final chatroom = context.read<ChatRoomCreateBloc>();
    final chatroomBloc = context.read<ChatRoomListBloc>();
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 7,
            ),
            child: BlocBuilder<ChatRoomListBloc, ChatRoomBaseState>(
                builder: (_, state) {
              final post = state.room;
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
                child: ListView.separated(
                  separatorBuilder: (_, i) {
                    return const SizedBox(
                      height: 3,
                    );
                  },
                  itemBuilder: (_, i) {
                    final members =
                        state.room[i].member.map((e) => e.toString()).toList();
                    logger.i("object is ${state.room[i].toUserName}");
                    var date = DateTime.fromMicrosecondsSinceEpoch(state
                        .room[i].finalMessageDateTime!.microsecondsSinceEpoch);
                    print("object is ${state.room[i].toUserName}");
                    return ChatRoomTile(
                        onLongPress: () {
                          StarlightUtils.dialog(AlertDialog(
                            title: const Text("Delete"),
                            content: const Text("Are you sure?"),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    StarlightUtils.pop();
                                  },
                                  child: const Text("Cancel")),
                              TextButton(
                                  onPressed: () {
                                    StarlightUtils.pop();
                                    chatroom.add(
                                        ChatRoomDeleteEvent(state.room[i]));
                                  },
                                  child: const Text("Delete"))
                            ],
                          ));
                        },
                        otherUserId: members[0] ==
                                Injection.get<AuthService>().currentUser!.uid
                            ? members[1]
                            : members[0],
                        message: state.room[i].finalMessage ?? "",
                        messageDateTime:
                            """ ${(date.difference(DateTime.now()).inMinutes * -1) > 60 ? ("${months[date.month - 1]}${(date.difference(DateTime.now()).inHours * -1) > 12 ? "${date.day} At ${date.hour - 12 == -12 ? "12" : date.hour > 12 ? date.hour - 12 : date.hour}: ${date.minute > 10 ? date.minute : "0${date.minute}"} ${date.hour > 12 ? "PM" : "AM"} " : "${date.hour > 12 ? date.hour - 12 : date.hour}:${date.minute > 10 ? date.minute : "0${date.minute}"} ${date.hour > 12 ? "PM" : "AM"} "} ") : ("${date.hour > 12 ? date.hour - 12 : date.hour}:${date.minute > 10 ? date.minute : "0${date.minute}"} ${date.hour > 12 ? "PM" : "AM"}")}  """,
                        onTap: () async {
                          final result = await StarlightUtils.pushNamed(
                              RouteNames.messaging,
                              arguments: state.room[i]);
                          chatroomBloc.add(RefreshChatRoomEvent());

                          logger.i("result is ${result.toString()}");
                        });
                  },
                  itemCount: state.room.length,
                ),
              );
            }),
          ),
          BlocConsumer<ChatRoomCreateBloc, ChatRoomCreateState>(
              builder: (_, state) {
            return Container();
          }, listener: (_, state) {
            logger.i("state is$state");
            if (state is ChatRoomDeletedState) {
              chatroomBloc.add(RefreshChatRoomEvent());
              StarlightUtils.snackbar(const SnackBar(content: Text("Deleted")));
            }
          })
        ],
      ),
    );
  }
}
