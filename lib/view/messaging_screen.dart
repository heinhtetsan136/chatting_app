import 'package:blca_project_app/controller/chatting/chatting_bloc.dart';
import 'package:blca_project_app/controller/chatting/chatting_event.dart';
import 'package:blca_project_app/controller/chatting/chatting_state.dart';
import 'package:blca_project_app/controller/chatting/send_data/send_data_bloc.dart';
import 'package:blca_project_app/controller/chatting/send_data/send_data_event.dart';
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
    final sendData = context.read<SendDataBloc>();

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
              child: BlocBuilder<ChattingBloc, ChattingState>(
                  buildWhen: (previous, current) {
                return previous.message.length != current.message.length;
              }, builder: (_, state) {
                logger.e("state messsage $state");

                if (state is ChattingLoadingState) {
                  return const Center(child: CircularProgressIndicator());
                }
                final messages = state.message.toList();
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
                      final isImage = messages[i].isText == false;
                      var date = DateTime.fromMicrosecondsSinceEpoch(
                          messages[i].sendingTime.microsecondsSinceEpoch);
                      print(date);
                      final message = messages[i];
                      myMessage = message.fromUser == auth.currentUser!.uid;
                      print("messages ");
                      print(date.hour);

                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            """ ${(date.difference(DateTime.now()).inMinutes * -1) > 60 ? ("${months[date.month - 1]}${(date.difference(DateTime.now()).inHours * -1) > 12 ? "${date.day} At ${date.hour - 12 == -12 ? "12" : date.hour > 12 ? date.hour - 12 : date.hour}: ${date.minute > 10 ? date.minute : "0${date.minute}"} ${date.hour > 12 ? "PM" : "AM"} " : "${date.hour > 12 ? date.hour - 12 : date.hour}:${date.minute > 10 ? date.minute : "0${date.minute}"} ${date.hour > 12 ? "PM" : "AM"} "} ") : ("${date.hour > 12 ? date.hour - 12 : date.hour}:${date.minute > 10 ? date.minute : "0${date.minute}"} ${date.hour > 12 ? "PM" : "AM"}")}  """,
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
                                    imageUrl: messages[i].data!)),

                          if (!isImage)
                            Align(
                              alignment: myMessage
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              child: GestureDetector(
                                onLongPress: () {
                                  StarlightUtils.dialog(Dialog(
                                    child: Container(
                                      height: 300,
                                      width: 200,
                                      color: Colors.green,
                                      child: Column(
                                        children: [
                                          const Text("Choose Your Option"),
                                          ListTile(
                                            title: const Text("Edit"),
                                            onTap: () {
                                              messagebloc.add(DeleteEvent(
                                                  messageId: message.id));
                                              StarlightUtils.pop();
                                            },
                                          ),
                                          ListTile(
                                            title: const Text("Delete"),
                                            onTap: () {
                                              messagebloc.add(DeleteEvent(
                                                  messageId: message.id));
                                              messagebloc.add(
                                                  const ChattingGetAllMessageEvent());
                                              StarlightUtils.pop();
                                            },
                                          )
                                        ],
                                      ),
                                    ),
                                  ));
                                  // logger.i("this is long press");
                                  // StarlightUtils.bottomSheet(builder: (_) {
                                  //   return SizedBox(
                                  //     height: 200,
                                  //     width: context.width * 0.8,
                                  //     child: Column(
                                  //       children: [
                                  //         Row(
                                  //           children: [
                                  //             const Text("Choose Your Option"),
                                  //             IconButton(
                                  //                 onPressed: () {
                                  //                   StarlightUtils.pop();
                                  //                 },
                                  //                 icon: const Icon(Icons.close))
                                  //           ],
                                  //         ),
                                  //         Expanded(
                                  //           child: Column(
                                  //             children: [
                                  //               ListTile(
                                  //                 title: const Text("Edit"),
                                  //                 trailing:
                                  //                     const Icon(Icons.edit),
                                  //                 onTap: () {},
                                  //               ),
                                  //               ListTile(
                                  //                 title: const Text("Delete"),
                                  //                 trailing: BlocConsumer<
                                  //                         SendDataBloc,
                                  //                         SendDataBaseState>(
                                  //                     listener: (_, state) {
                                  //                   if (state
                                  //                       is SendDataErrorState) {
                                  //                     StarlightUtils.snackbar(
                                  //                         SnackBar(
                                  //                             content: Text(
                                  //                                 state
                                  //                                     .error)));
                                  //                   }
                                  //                   if (state
                                  //                       is SendDataLoadedState) {
                                  //                     StarlightUtils.snackbar(
                                  //                         const SnackBar(
                                  //                             content: Text(
                                  //                                 "Deleted")));
                                  //                     StarlightUtils.pop();
                                  //                   }
                                  //                 }, builder: (_, state) {
                                  //                   if (state
                                  //                       is SendDataLoadingState) {
                                  //                     return const Center(
                                  //                         child:
                                  //                             CircularProgressIndicator());
                                  //                   }
                                  //                   return const Icon(
                                  //                       Icons.delete);
                                  //                 }),
                                  //                 onTap: () {
                                  //                   sendData.add(DeleteEvent(
                                  //                       messageId: message.id));
                                  //                 },
                                  //               )
                                  //             ],
                                  //           ),
                                  //         ),
                                  //       ],
                                  //     ),
                                  //   );
                                  // });
                                },
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Text(
                                      " ${messages[i].data}",
                                      style: const TextStyle(),
                                    ),
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
                    itemCount: messages.length,
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
                      controller: sendData.textEditingController,
                      focusNode: sendData.focusNode,
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
                          sendData.add(const SendPhotoEvent());
                        },
                        icon: const Icon(Icons.image_outlined),
                      ),
                      IconButton(
                          onPressed: () {
                            sendData.add(const SendMessageEvent());
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
