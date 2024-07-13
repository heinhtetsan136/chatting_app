import 'package:blca_project_app/controller/chat_room/chat_room_sendMessage_bloc.dart/chat_room_bloc.dart';
import 'package:blca_project_app/controller/contact_controller/contact_event.dart';
import 'package:blca_project_app/controller/contact_controller/contact_state.dart';
import 'package:blca_project_app/controller/contact_controller/controller_bloc.dart';
import 'package:blca_project_app/route/route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:starlight_utils/starlight_utils.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final contactbloc = context.read<ContactBloc>();
    final chattingbloc = context.read<ChatRoomBloc>();
    return Scaffold(
      appBar: AppBar(
        leading: TextButton(onPressed: () {}, child: const Text("Edit")),
        actions: [
          OutlinedButton.icon(
            onPressed: () async {},
            label: const Text("New"),
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
        child: Column(
          children: [
            TextFormField(
              decoration: const InputDecoration(
                isDense: true,
                suffixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: BlocBuilder<ContactBloc, ContactBaseState>(
                  builder: (_, state) {
                final post = state.posts;
                if (state is ContactLoadingState) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (post.isEmpty) {
                  return Center(
                      child: TextButton(
                    onPressed: () {
                      contactbloc.add(RefreshContactEvent());
                    },
                    child: const Text("No Data"),
                  ));
                }
                return RefreshIndicator(
                  onRefresh: () async {
                    contactbloc.add(RefreshContactEvent());
                  },
                  child: ListView.separated(
                      separatorBuilder: (_, i) {
                        return const SizedBox(
                          height: 1,
                        );
                      },
                      itemCount: state.posts.length,
                      itemBuilder: (_, i) {
                        return ChatRoom(
                            onTap: () {
                              chattingbloc.chatRoomCreate(state.posts[i]);
                              StarlightUtils.pushNamed(RouteNames.chatRoom,
                                  arguments: state.posts[i]);
                            },
                            name: state.posts[i].email,
                            message: "abacajfkjaljfkj");
                      }),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatRoom extends StatelessWidget {
  final String name, message;
  final void Function() onTap;
  const ChatRoom(
      {super.key,
      required this.name,
      required this.message,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    final double width = context.width;
    final double height = context.height * 0.1;
    return GestureDetector(
      onTap: onTap,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 10),
          child: SizedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const CircleAvatar(
                      radius: 25,
                      child: Icon(Icons.person),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(name),
                          Text(message),
                        ],
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Container(
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: Colors.green),
                    width: 16,
                    height: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
