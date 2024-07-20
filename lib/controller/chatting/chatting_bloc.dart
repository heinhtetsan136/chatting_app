import 'package:blca_project_app/controller/chatting/chatting_event.dart';
import 'package:blca_project_app/controller/chatting/chatting_state.dart';
import 'package:blca_project_app/injection.dart';
import 'package:blca_project_app/logger.dart';
import 'package:blca_project_app/repo/authService.dart';
import 'package:blca_project_app/repo/chatRoom_model.dart';
import 'package:blca_project_app/repo/chattingService.dart';
import 'package:blca_project_app/repo/message.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChattingBloc extends Bloc<ChattingEvent, ChattingState> {
  final AuthService _authService = Injection.get<AuthService>();
  final ChatRoom chatRoom;
  final FocusNode focusNode = FocusNode();
  final TextEditingController textEditingController = TextEditingController();
  final Chattingservice chatRoomService = Injection.get<Chattingservice>();

  ChattingBloc(super.initialState, this.chatRoom) {
    chatRoomService.contactListener(contactListener, chatRoom.id);
    on<ChattingGetAllMessageEvent>((event, emit) async {
      final messages = state.message.toList();
      if (messages.isEmpty) {
        emit(ChattingLoadingState(messages));
      } else {
        emit(ChattingSoftLoadingState(messages));
      }

      final result = await chatRoomService.getMessages(chatRoom.id);
      logger.i("message is  ${result.hasError ?? ""}");
      if (result.hasError) {
        emit(ChattingErrorState(messages, result.error!.message.toString()));
        return;
      }
      emit(ChattingLoadedState(result.data));
    });
    on<ChattingRefreshMessageEvent>((_, emit) {});
    on<ChattingNewMessageEvent>((event, emit) {
      emit(ChattingLoadedState(event.post));
    });
    add(const ChattingGetAllMessageEvent());
  }
  void sendMessage() async {
    final message = textEditingController.text;
    if (message.isEmpty) {
      return;
    }
    textEditingController.clear();
    final payload = MessageParams.toCreate(
      chatRoomId: chatRoom.id,
      data: message,
      fromUser: _authService.currentUser!.uid,
    );
    await chatRoomService.sendMessage(payload);

    focusNode.unfocus();
  }

  void contactListener(Message message) {
    final copied = state.message.toList();
    if (copied.isEmpty) {
      add(const ChattingGetAllMessageEvent());
      return;
    }
    print("new message $copied");
    final index = copied.indexOf(message);
    if (index == -1) {
      copied.insert(0, (message));
    } else {
      copied[index] = message;
    }
    print("new message addd $copied");
    add(ChattingNewMessageEvent(copied));
  }

  @override
  Future<void> close() {
    textEditingController.dispose();
    focusNode.dispose();
    // TODO: implement close
    return super.close();
  }
}
