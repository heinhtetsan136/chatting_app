import 'dart:async';

import 'package:blca_project_app/controller/chat_room/chat_room_list_controller/chat_room_list_event.dart';
import 'package:blca_project_app/controller/chat_room/chat_room_list_controller/chat_room_list_state.dart';
import 'package:blca_project_app/injection.dart';
import 'package:blca_project_app/logger.dart';
import 'package:blca_project_app/repo/authService.dart';
import 'package:blca_project_app/repo/chatRoom_model.dart';
import 'package:blca_project_app/repo/chatroom_service.dart';
import 'package:blca_project_app/repo/user_model.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatRoomListBloc extends Bloc<ChatRoomBaseEvent, ChatRoomBaseState> {
  final AuthService _authService = Injection.get<AuthService>();
  StreamSubscription? _chatroomStream;
  final TextEditingController textController = TextEditingController();
  final FocusNode focusNode = FocusNode();
  final ChatRoomService chatRoomService = Injection.get<ChatRoomService>();
  final StreamController<List<ChatRoom>> roomStream =
      StreamController<List<ChatRoom>>.broadcast();
  ChatRoomListBloc() : super(const ChatRoomInitialState([])) {
    final List<ChatRoom> room = [];
    // void chatRoomParser(event) {
    //   for (var i in event.docs) {
    //     final model = ChatRoom.fromJson(i.data());
    //     final index = room.indexOf(model);
    //     if (index == -1) {
    //       room.add(model);
    //     } else {
    //       room[index] = model;
    //     }
    //   }
    //   roomStream.add(room);
    // }

    // final doc = chatRoomService.db.collection("ChatRoom");
    // final result =
    //     doc.where("member", arrayContains: _authService.currentUser?.uid);

    // _chatroomStream = result.snapshots().listen(chatRoomParser);
    on<NewChatRoomEvent>((event, emit) {
      print("new Message Event");
      emit(ChatRoomLoadedState(event.post));
    });
    on<GetChatRoomEvent>((event, emit) async {
      print("Get Message Event");
      if (state is ChatRoomLoadingState || state is ChatRoomSoftLoadingState) {
        return;
      }
      print("this is get ${state.message}");
      final messages = state.message;
      if (messages.isEmpty) {
        emit(ChatRoomLoadingState(messages));
      } else {
        emit(ChatRoomSoftLoadingState(messages));
      }
      final result = await chatRoomService.getListOfChatRoom();

      if (result.hasError) {
        emit(ChatRoomErrorState(result.error!.message, messages));
      }

      emit(ChatRoomLoadedState(result.data!));
    });
    on<RefreshChatRoomEvent>((event, emit) async {
      print("refresh Message Event");
      final messages = state.message;
      if (messages.isEmpty) {
        emit(ChatRoomLoadingState(messages));
      }
      final result = await chatRoomService.getListOfChatRoom();
      if (result.hasError) {
        emit(ChatRoomErrorState(result.error!.message, messages));
      }
      emit(ChatRoomLoadedState(result.data!));
    });
    add(GetChatRoomEvent());
    chatRoomService.contactListener(contactListener);
  }
  void contactListener(ChatRoom room) {
    final copied = state.message.toList();
    if (copied.isEmpty) {
      add(GetChatRoomEvent());
      return;
    }
    print("new message $copied");
    final index = copied.indexOf(room);
    if (index == -1) {
      copied.insert(0, (room));
    } else {
      copied[index] = room;
    }
    print("new message addd $copied");
    add(NewChatRoomEvent(copied));
  }

  void chatRoomCreate(ContactUser other) async {}

  @override
  Future<void> close() {
    logger.i("chat Room Bloc Close");
    textController.dispose();
    focusNode.dispose();
    roomStream.close();
    _chatroomStream?.cancel();
    // TODO: implement close
    return super.close();
  }
}
