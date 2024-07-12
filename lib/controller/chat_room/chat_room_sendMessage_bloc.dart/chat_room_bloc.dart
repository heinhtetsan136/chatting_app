import 'package:blca_project_app/controller/chat_room/chat_room_sendMessage_bloc.dart/chat_room_event.dart';
import 'package:blca_project_app/controller/chat_room/chat_room_sendMessage_bloc.dart/chat_room_state.dart';
import 'package:blca_project_app/injection.dart';
import 'package:blca_project_app/repo/authService.dart';
import 'package:blca_project_app/repo/chatRoom_model.dart';
import 'package:blca_project_app/repo/message.dart';
import 'package:blca_project_app/repo/messaging_service.dart';
import 'package:blca_project_app/repo/user_model.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatRoomBloc extends Bloc<ChatRoomBaseEvent, ChatRoomBaseState> {
  final ContactUser otherUser;
  final AuthService _authService = Injection.get<AuthService>();
  final TextEditingController textController = TextEditingController();
  final MessagingService _messagingService = Injection.get<MessagingService>();
  ChatRoomBloc(this.otherUser) : super(const ChatRoomInitialState([])) {
    on<GetMessageEvent>((event, emit) async {
      _messagingService.contactListener(contactListener);
      if (state is ChatRoomLoadingState || state is ChatRoomSoftLoadingState) {
        return;
      }
      final messages = state.message;
      if (messages.isEmpty) {
        emit(ChatRoomLoadingState(messages));
      } else {
        emit(ChatRoomSoftLoadingState(messages));
      }
      final result = await _messagingService.getMessage(otherUser);
      if (result.hasError) {
        emit(ChatRoomErrorState(result.error!.message, messages));
      }
      emit(ChatRoomLoadedState(result.data!));
    });
    on<RefreshMessageEvent>((event, emit) async {
      final messages = state.message;
      if (messages.isEmpty) {
        emit(ChatRoomLoadingState(messages));
      }
      final result = await _messagingService.getMessage(otherUser);
      if (result.hasError) {
        emit(ChatRoomErrorState(result.error!.message, messages));
      }
      emit(ChatRoomLoadedState(result.data!));
    });
    add(GetMessageEvent());
  }
  void contactListener(Messages post) {
    final copied = state.message.toList();
    final index = copied.indexOf(post);
    if (index == -1) {
      copied.add(post);
    } else {
      copied[index] = post;
    }
    add(NewMessageEvent(copied));
  }

  void sendMessage() async {
    if (textController.text.isEmpty) {
      return;
    }

    final result = await _messagingService.SendMessage(ChatRoomParams(
        text: textController.text,
        fromUserId: _authService.currentUser!.uid,
        toUserId: otherUser.uid));
  }
}
