import 'package:blca_project_app/controller/chatting/chatting_bloc.dart';
import 'package:blca_project_app/controller/chatting/chatting_state.dart';
import 'package:blca_project_app/injection.dart';
import 'package:blca_project_app/logger.dart';
import 'package:blca_project_app/repo/authService.dart';
import 'package:blca_project_app/repo/chatRoom_model.dart';
import 'package:blca_project_app/view/setting/widget/network_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:starlight_utils/starlight_utils.dart';

class MessagingScreen extends StatelessWidget {
  final ChatRoom chatRoom;
  const MessagingScreen({super.key, required this.chatRoom});

  @override
  Widget build(BuildContext context) {
    final List<String> user = chatRoom.member.map((e) => e.toString()).toList();
    final AuthService auth = Injection.get<AuthService>();
    bool myMessage = false;
    final messagebloc = context.read<ChattingBloc>();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () {
              StarlightUtils.pop();
            },
            icon: const Icon(Icons.arrow_back)),
        title: Row(
          children: [
            NetworkProfile(
              profileUrl: "",
              radius: 40,
              onFail: CircleAvatar(
                child: Text(
                    "${user[0] == auth.currentUser!.uid ? user[1][0] : user[0][0]}      "),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Text(
                  user[0] == auth.currentUser!.uid ? user[1][3] : user[0][3]),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            Expanded(
              child: Container(child:
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
                return ListView.separated(
                  reverse: true,
                  separatorBuilder: (_, i) {
                    return const SizedBox(height: 10);
                  },
                  itemBuilder: (_, i) {
                    final message = state.message[i];
                    myMessage = message.fromUser == auth.currentUser!.uid;
                    print("messages ");
                    return Align(
                      alignment: myMessage
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            " ${state.message[i].data}",
                            style: const TextStyle(),
                          ),
                        ),
                      ),
                    );
                  },
                  itemCount: state.message.length,
                );
              })),
            ),
            Container(
              height: 80,
              width: context.width,
              color: Colors.white,
              child: Row(
                children: [
                  SizedBox(
                      width: context.width * 0.8,
                      child: TextFormField(
                        controller: messagebloc.textEditingController,
                        focusNode: messagebloc.focusNode,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(9))),
                      )),
                  IconButton(
                      onPressed: () {
                        messagebloc.sendMessage();
                      },
                      icon: const Icon(Icons.send))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
