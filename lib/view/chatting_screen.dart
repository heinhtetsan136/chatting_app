import 'package:blca_project_app/controller/chat_room/chat_room_sendMessage_bloc.dart/chat_room_bloc.dart';
import 'package:blca_project_app/controller/chat_room/chat_room_sendMessage_bloc.dart/chat_room_state.dart';
import 'package:blca_project_app/repo/user_model.dart';
import 'package:blca_project_app/view/setting/widget/network_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:starlight_utils/starlight_utils.dart';

class ChatRoomScreen<T extends ContactUser> extends StatelessWidget {
  const ChatRoomScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<ChatRoomBloc>();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () {
              StarlightUtils.pop();
            },
            icon: const Icon(Icons.arrow_back)),
        title: const Row(
          children: [
            NetworkProfile(
              profileUrl: "",
              radius: 40,
              onFail: CircleAvatar(
                child: Text("A"),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Text("Account Name"),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            Expanded(
              child: Container(
                child: BlocBuilder<ChatRoomBloc, ChatRoomBaseState>(
                    builder: (_, state) {
                  print("state is $state");
                  if (state is ChatRoomLoadingState) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return ListView.separated(
                    separatorBuilder: (_, i) {
                      return const SizedBox(height: 10);
                    },
                    itemBuilder: (_, i) {
                      print("messages ");
                      return Align(
                        alignment: Alignment.centerLeft,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              " state.message[i].message",
                              style: TextStyle(),
                            ),
                          ),
                        ),
                      );
                    },
                    itemCount: state.message.length,
                  );
                }),
              ),
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
                        focusNode: bloc.focusNode,
                        controller: bloc.textController,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(9))),
                      )),
                  IconButton(
                      onPressed: () {
                        bloc.textController.clear();
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
