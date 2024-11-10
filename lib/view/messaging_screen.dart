import 'package:blca_project_app/controller/chatting/chatting_bloc.dart';
import 'package:blca_project_app/controller/chatting/chatting_event.dart';
import 'package:blca_project_app/controller/chatting/chatting_state.dart';
import 'package:blca_project_app/controller/chatting/send_data/send_data_bloc.dart';
import 'package:blca_project_app/controller/chatting/send_data/send_data_event.dart';
import 'package:blca_project_app/controller/chatting/send_data/send_data_state.dart';
import 'package:blca_project_app/controller/videoCall/db_controller/video_call_db_blco.dart';
import 'package:blca_project_app/controller/videoCall/db_controller/video_call_db_event.dart';
import 'package:blca_project_app/controller/videoCall/db_controller/video_call_db_state.dart';
import 'package:blca_project_app/injection.dart';
import 'package:blca_project_app/logger.dart';
import 'package:blca_project_app/repo/authService.dart';
import 'package:blca_project_app/repo/chatRoom_model.dart';
import 'package:blca_project_app/route/route.dart';
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
    bool isEdit = false;

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
    final videobloc = context.read<VideoCallDbBlco>();

    return Scaffold(
      body: Padding(
        padding:
            const EdgeInsets.only(left: 10, right: 10, top: 44, bottom: 10),
        child: Stack(
          children: [
            Column(
              children: [
                Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          StarlightUtils.pop();
                        },
                        icon: const Icon(Icons.arrow_back)),
                    OtherUserNames(
                        otherUserId: user[0] == auth.currentUser!.uid
                            ? user[1]
                            : user[0],
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
                        child: OtherUserNames(
                            builder: (user) => Text(
                                  user.email ?? "No Name",
                                ),
                            otherUserId: user[0] == auth.currentUser!.uid
                                ? user[1]
                                : user[0])),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                            onPressed: () {
                              videobloc.add(VideoCallDbCallEvent(
                                  user[0] == auth.currentUser!.uid
                                      ? user[1]
                                      : user[0]));
                            },
                            icon: const Icon(Icons.call))
                      ],
                    ),
                  ],
                ),
                Expanded(
                  child: BlocBuilder<ChattingBloc, ChattingState>(
                      builder: (_, state) {
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
                              ),
                              if (isImage)
                                Align(
                                    alignment: myMessage
                                        ? Alignment.centerRight
                                        : Alignment.centerLeft,
                                    child: Gesture(
                                      onTap: () {
                                        sendData.add(DeleteEvent(
                                          message: message,
                                        ));

                                        StarlightUtils.pop();
                                      },
                                      child: CachedNetworkImage(
                                          fit: BoxFit.cover,
                                          progressIndicatorBuilder: (context,
                                                  url, downloadProgress) =>
                                              Center(
                                                child:
                                                    CircularProgressIndicator(
                                                        value: downloadProgress
                                                            .progress),
                                              ),
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.error),
                                          height: 200,
                                          width: 200,
                                          imageUrl: messages[i].data!),
                                    )),
                              if (!isImage)
                                Align(
                                  alignment: myMessage
                                      ? Alignment.centerRight
                                      : Alignment.centerLeft,
                                  child: Gesture(
                                    onTap: () {
                                      sendData.add(DeleteEvent(
                                        message: message,
                                      ));

                                      StarlightUtils.pop();
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
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
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
                BlocConsumer<SendDataBloc, SendDataBaseState>(
                    listener: (_, state) {
                  if (state is SendDataErrorState) {
                    StarlightUtils.snackbar(
                        SnackBar(content: Text(state.error)));
                  }
                  if (state is SendDataDeleteState) {
                    StarlightUtils.snackbar(
                        const SnackBar(content: Text("Sucessfully deleted")));
                    messagebloc.add(const ChattingRefreshMessageEvent());
                  }
                }, builder: (_, state) {
                  if (state is SendDataLoadingState) {
                    return const Center(
                      child: LinearProgressIndicator(
                        backgroundColor: Colors.blue,
                        color: Colors.green,
                        minHeight: 2,
                      ),
                    );
                  }
                  return const SizedBox();
                }),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SizedBox(
                        width: context.width * 0.67,
                        child: TextFormField(
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
                            icon: const Icon(Icons.add_a_photo),
                          ),
                          IconButton(
                              onPressed: () {
                                sendData.add(const SendMessageEvent());
                              },
                              icon: const Icon(Icons.send))
                        ],
                      )),
                    )
                  ],
                ),
              ],
            ),
            BlocConsumer<VideoCallDbBlco, VideoCallDbState>(
              builder: (_, state) {
                if (state is VideoCallDbLoadingState) {
                  return Container(
                    height: context.height,
                    width: context.width,
                    decoration: const BoxDecoration(
                      color: Color.fromRGBO(255, 255, 255, 1),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(state.caller.displayName ?? state.caller.email),
                          const CircularProgressIndicator(),
                          const Text("Calling..."),
                          IconButton(
                              onPressed: () {
                                videobloc.add(
                                    VideoCallDbDeclineEvent(state.caller.uid));
                              },
                              icon: const Icon(Icons.call_end))
                        ],
                      ),
                    ),
                  );
                }
                return const SizedBox();
              },
              listener: (_, state) {
                logger.i("calldb state $state");
                if (state is VideoCallDbSucessState) {
                  final model = state.model;
                  StarlightUtils.pushNamed(RouteNames.call,
                      arguments: model.id);
                }
                if (state is VideoCallDbLeaveState) {
                  StarlightUtils.snackbar(const SnackBar(
                    content: Text("Call Leave"),
                  ));
                }
                if (state is VideoCalDbErrorState) {
                  StarlightUtils.snackbar(SnackBar(
                    content: Text(state.message),
                  ));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class Gesture extends StatelessWidget {
  final void Function() onTap;
  final Widget child;
  const Gesture({super.key, required this.onTap, required this.child});

  @override
  Widget build(BuildContext context) {
    final messagesbloc = context.read<ChattingBloc>();
    return GestureDetector(
        onLongPress: () {
          StarlightUtils.dialog(Dialog(
              child: SizedBox(
            height: 300,
            width: 200,
            child: Column(
              children: [
                const Text("Choose Your Option"),
                ListTile(title: const Text("Delete"), onTap: onTap)
              ],
            ),
          )));
        },
        child: child);
  }
}
