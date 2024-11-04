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
    final theme = context.theme;
    final chatRoomListBloc = context.read<ChatRoomListBloc>();
    final contactbloc = context.read<ContactBloc>();
    final createChatRoom = context.read<ChatRoomCreateBloc>();
    final listTiletheme = context.theme.listTileTheme
        .copyWith(tileColor: context.theme.scaffoldBackgroundColor);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Contact List",
                  style: TextStyle(
                      fontSize: 20, color: theme.textTheme.bodyLarge?.color),
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
                              height: 4,
                            );
                          },
                          itemCount: state.posts.length,
                          itemBuilder: (_, i) {
                            final shortName = state.posts[i].displayName?[0] ??
                                state.posts[i].email[0] ??
                                state.posts[i].uid[0];
                            final profileUrl = state.posts[i].photoURL;
                            return ListTile(
                              tileColor: listTiletheme.tileColor,
                              contentPadding: const EdgeInsets.all(5),
                              onTap: () {
                                createChatRoom
                                    .add(ChatRoomOnCreateEvent(state.posts[i]));
                              },
                              leading: profileUrl?.isEmpty == true
                                  ? CircleAvatar(
                                      maxRadius: 50,
                                      child: Text(
                                        shortName,
                                      ),
                                    )
                                  : NetworkProfile(
                                      radius: 50,
                                      onFail: CircleAvatar(
                                        maxRadius: 35,
                                        child: Text(
                                          shortName,
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

  final String message, messageDateTime;
  final void Function() onTap, onLongPress;
  const ChatRoomTile(
      {super.key,
      required this.messageDateTime,
      required this.onLongPress,
      required this.otherUserId,
      required this.message,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    final double width = context.width;
    final double height = context.height * 0.1;
    final theme = context.theme;
    final textColor = theme.textTheme.bodyLarge?.color;
    return GestureDetector(
      onLongPress: onLongPress,
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: theme.bottomNavigationBarTheme.backgroundColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                      Row(
                        children: [
                          OtherUserNames(
                            otherUserId: otherUserId,
                            builder: (user) {
                              return Text(
                                user.displayName ?? user.email ?? "No Name",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: textColor,
                                ),
                              );
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8, left: 5),
                            child: Container(
                              decoration: const BoxDecoration(
                                  shape: BoxShape.circle, color: Colors.green),
                              width: 6,
                              height: 6,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          message.startsWith("https://")
                              ? const Text("Send a Photo")
                              : Text(
                                  message,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                    color: textColor,
                                  ),
                                ),
                          const SizedBox(
                            width: 30,
                          ),
                          Text(
                            messageDateTime,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w200,
                              color: textColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
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
