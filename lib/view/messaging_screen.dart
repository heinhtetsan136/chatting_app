import 'package:blca_project_app/controller/chatting/chatting_bloc.dart';
import 'package:blca_project_app/controller/chatting/chatting_event.dart';
import 'package:blca_project_app/controller/chatting/chatting_state.dart';
import 'package:blca_project_app/injection.dart';
import 'package:blca_project_app/logger.dart';
import 'package:blca_project_app/repo/authService.dart';
import 'package:blca_project_app/repo/chatRoom_model.dart';
import 'package:blca_project_app/view/contact_screen.dart';
import 'package:blca_project_app/view/setting/widget/network_profile.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:starlight_utils/starlight_utils.dart';

class MessagingScreen extends StatelessWidget {
  final ChatRoom chatRoom;
  const MessagingScreen({super.key, required this.chatRoom});

  @override
  Widget build(BuildContext context) {
    final FirebaseFirestore firestore = Injection.get<FirebaseFirestore>();
    final List<String> user = chatRoom.member.map((e) => e.toString()).toList();
    final AuthService auth = Injection.get<AuthService>();
    bool myMessage = false;

    final messagebloc = context.read<ChattingBloc>();
    return Scaffold(
      body: Padding(
        padding:
            const EdgeInsets.only(left: 10, right: 10, top: 44, bottom: 10),
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                    onPressed: () {
                      StarlightUtils.pop();
                    },
                    icon: const Icon(Icons.arrow_back)),
                OtherUserNames(
                    otherUserId:
                        user[0] == auth.currentUser!.uid ? user[1] : user[0],
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
                    child: OtherUserNames(
                        builder: (user) => Text(
                              user.email ?? "No Name",
                              style: const TextStyle(
                                  fontWeight: FontWeight.w400, fontSize: 20),
                            ),
                        otherUserId: user[0] == auth.currentUser!.uid
                            ? user[1]
                            : user[0]))
              ],
            ),
            Expanded(
              child:
                  BlocBuilder<ChattingBloc, ChattingState>(builder: (_, state) {
                logger.e("state messsage $state");

                if (state is ChattingLoadingState) {
                  return const Center(child: CircularProgressIndicator());
                }
                final messages = state.message;
                if (messages.isEmpty) {
                  return const Center(
                    child: Text("No Message"),
                  );
                }
                return RefreshIndicator(
                  onRefresh: () async {
                    messagebloc.add(const ChattingRefreshMessageEvent());
                  },
                  child: ListView.separated(
                    reverse: true,
                    separatorBuilder: (_, i) {
                      return const SizedBox(height: 30);
                    },
                    itemBuilder: (_, i) {
                      final isImage = state.message[i].isText == false;
                      var date = DateTime.fromMicrosecondsSinceEpoch(
                          state.message[i].sendingTime.microsecondsSinceEpoch);
                      print(date);
                      final message = state.message[i];
                      myMessage = message.fromUser == auth.currentUser!.uid;
                      print("messages ");
                      print(date.hour);

                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            """${(date.difference(DateTime.now()).inMinutes * -1) > 60 ? ("${(date.difference(DateTime.now()).inHours * -1) > 12 ? "${date.day} days : ${date.hour - 12 == -12 ? "12" : date.hour > 12 ? date.hour - 12 : date.hour} hour" : "${date.hour > 12 ? date.hour - 12 : date.hour}:${date.minute > 10 ? date.minute : "0${date.minute}"} ${date.hour > 12 ? "PM" : "AM"} "} ") : ("${date.hour > 12 ? date.hour - 12 : date.hour}:${date.minute > 10 ? date.minute : "0${date.minute}"} ${date.hour > 12 ? "PM" : "AM"}")}  """,
                            style: const TextStyle(fontWeight: FontWeight.w300),
                          ),
                          if (isImage)
                            Align(
                                alignment: myMessage
                                    ? Alignment.centerRight
                                    : Alignment.centerLeft,
                                child: CachedNetworkImage(
                                    fit: BoxFit.cover,
                                    progressIndicatorBuilder: (context, url,
                                            downloadProgress) =>
                                        Center(
                                          child: CircularProgressIndicator(
                                              value: downloadProgress.progress),
                                        ),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                    height: 200,
                                    width: 200,
                                    imageUrl: state.message[i].data!)),

                          if (!isImage)
                            Align(
                              alignment: myMessage
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Text(
                                    " ${state.message[i].data}",
                                    style: const TextStyle(),
                                  ),
                                ),
                              ),
                            ),
                          // Text(
                          //   "${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute}:${date.second}",
                          // ),
                          //  Text(
                          //    """${(date.difference(DateTime.now()).inMinutes * -1) > 60 ? ("${(date.difference(DateTime.now()).inHours * -1) > 12 ? "${date.difference(DateTime.now()).inDays * -1} days" : "${date.difference(DateTime.now()).inHours * -1} hour"} ") : ("${date.difference(DateTime.now()).inMinutes * -1} minutes")} ago" """),
                        ],
                      );
                    },
                    itemCount: state.message.length,
                  ),
                );
              }),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(
                    width: context.width * 0.67,
                    child: TextFormField(
                      style: const TextStyle(),
                      keyboardType: TextInputType.multiline,
                      maxLines: 10,
                      minLines: 1,
                      controller: messagebloc.textEditingController,
                      focusNode: messagebloc.focusNode,
                      decoration: InputDecoration(
                          isDense: true,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(9))),
                    )),
                Expanded(
                  child: SizedBox(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: () {
                          messagebloc.pickImage();
                        },
                        icon: const Icon(Icons.image_outlined),
                      ),
                      IconButton(
                          onPressed: () {
                            messagebloc.sendMessage();
                          },
                          icon: const Icon(Icons.send)),
                    ],
                  )),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
