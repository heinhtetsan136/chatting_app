import 'package:blca_project_app/repo/chatRoom_model.dart';
import 'package:blca_project_app/repo/message.dart';

abstract class ChatRoomBaseState {
  final List<ChatRoom> message;
  const ChatRoomBaseState(this.message);
}

class ChatRoomInitialState extends ChatRoomBaseState {
  const ChatRoomInitialState(super.message);
}

class ChatRoomLoadingState extends ChatRoomBaseState {
  const ChatRoomLoadingState(super.message);
}

class ChatRoomSoftLoadingState extends ChatRoomBaseState {
  const ChatRoomSoftLoadingState(super.message);
}

class ChatRoomLoadedState extends ChatRoomBaseState {
  const ChatRoomLoadedState(super.message);
}

class ChatRoomErrorState extends ChatRoomBaseState {
  final String error;
  const ChatRoomErrorState(this.error, super.message);
}
