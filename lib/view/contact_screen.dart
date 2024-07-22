import 'package:blca_project_app/controller/chat_room/chat_room_create_controller/chat_room_create_bloc.dart';
import 'package:blca_project_app/controller/chat_room/chat_room_create_controller/chat_room_create_event.dart';
import 'package:blca_project_app/controller/chat_room/chat_room_create_controller/chat_room_create_state.dart';
import 'package:blca_project_app/controller/chat_room/chat_room_list_controller/chat_room_list_bloc.dart';
import 'package:blca_project_app/controller/contact_controller/contact_event.dart';
import 'package:blca_project_app/controller/contact_controller/contact_state.dart';
import 'package:blca_project_app/controller/contact_controller/controller_bloc.dart';
import 'package:blca_project_app/injection.dart';
import 'package:blca_project_app/logger.dart';
import 'package:blca_project_app/repo/user_model.dart';
import 'package:blca_project_app/route/route.dart';
import 'package:blca_project_app/view/setting/widget/network_profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:starlight_utils/starlight_utils.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final chatRoomListBloc = context.read<ChatRoomListBloc>();
    final contactbloc = context.read<ContactBloc>();
    final createChatRoom = context.read<ChatRoomCreateBloc>();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
        child: Stack(
          children: [
            Column(
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
                  height: 20,
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
                              height: 20,
                            );
                          },
                          itemCount: state.posts.length,
                          itemBuilder: (_, i) {
                            final shortName = state.posts[i].displayName?[0] ??
                                state.posts[i].email[0] ??
                                state.posts[i].uid[0];
                            final profileUrl = state.posts[i].photoURL;
                            return ListTile(
                              onTap: () {
                                createChatRoom
                                    .add(ChatRoomOnCreateEvent(state.posts[i]));
                              },
                              leading: profileUrl?.isEmpty == true
                                  ? CircleAvatar(
                                      maxRadius: 50,
                                      child: Text(
                                        shortName,
                                        style: const TextStyle(
                                          fontSize: 28,
                                        ),
                                      ),
                                    )
                                  : NetworkProfile(
                                      radius: 50,
                                      onFail: CircleAvatar(
                                        maxRadius: 35,
                                        child: Text(
                                          shortName,
                                          style: const TextStyle(
                                            fontSize: 28,
                                          ),
                                        ),
                                      ),
                                      profileUrl: profileUrl ?? "",
                                    ),
                              title: Text(state.posts[i].displayName ??
                                  state.posts[i].email ??
                                  " No Name"),
                            );
                          }),
                    );
                  }),
                ),
              ],
            ),
            BlocConsumer<ChatRoomCreateBloc, ChatRoomCreateState>(
                listener: (_, state) {
              logger.wtf("state is $state");
              if (state is ChatRoomCreateSuccessState) {
                StarlightUtils.pushNamed(RouteNames.messaging,
                    arguments: state.room);
              }
              if (state is ChatRoomCreateErrorState) {
                StarlightUtils.snackbar(SnackBar(content: Text(state.error)));
              }
            }, builder: (_, state) {
              if (state is ChatRoomCreateLoadingState) {
                return SizedBox(
                  width: context.width,
                  height: context.height,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              return const SizedBox();
            })
          ],
        ),
      ),
    );
  }
}

class ChatRoomTile extends StatelessWidget {
  final String otherUserId;

  final String message;
  final void Function() onTap;
  const ChatRoomTile(
      {super.key,
      required this.otherUserId,
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
                    OtherUserNames(
                        otherUserId: otherUserId,
                        builder: (user) {
                          final shortName = user.email[0] ?? user.uid[0];
                          final profileUrl = user.photoURL ?? "";
                          if (profileUrl.isEmpty == true) {
                            return CircleAvatar(
                              maxRadius: 20,
                              child: Text(
                                shortName,
                                style: const TextStyle(
                                  fontSize: 28,
                                ),
                              ),
                            );
                          }
                          return NetworkProfile(
                            radius: 20,
                            profileUrl: profileUrl,
                            onFail: CircleAvatar(
                              maxRadius: 20,
                              child: Text(
                                shortName,
                                style: const TextStyle(
                                  fontSize: 28,
                                ),
                              ),
                            ),
                          );
                        }),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          OtherUserNames(
                            otherUserId: otherUserId,
                            builder: (user) {
                              return Text(user.email ?? "No Name");
                            },
                          ),
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

class OtherUserNames extends StatelessWidget {
  final String otherUserId;
  final Widget Function(ContactUser) builder;
  const OtherUserNames(
      {super.key, required this.otherUserId, required this.builder});

  @override
  Widget build(BuildContext context) {
    final FirebaseFirestore firestore = Injection.get<FirebaseFirestore>();
    return StreamBuilder(
        stream: firestore
            .collection("users")
            .where("uid", isEqualTo: otherUserId)
            .snapshots(),
        builder: (context, snap) {
          if (snap.hasData == false) {
            return const Text("No Name");
          }
          final user = ContactUser.fromJson(snap.data!.docs.first.data());
          return builder(user);
        });
  }
}
