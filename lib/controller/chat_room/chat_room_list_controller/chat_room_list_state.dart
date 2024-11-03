import 'package:blca_project_app/repo/chatRoom_model.dart';
import 'package:equatable/equatable.dart';

abstract class ChatRoomBaseState extends Equatable {
  final List<ChatRoom> room;
  @override
  // TODO: implement props
  List<Object?> get props => room;
  const ChatRoomBaseState(this.room);
}

class ChatRoomInitialState extends ChatRoomBaseState {
  const ChatRoomInitialState(super.room);
}

class ChatRoomLoadingState extends ChatRoomBaseState {
  const ChatRoomLoadingState(super.room);
}

class ChatRoomSoftLoadingState extends ChatRoomBaseState {
  const ChatRoomSoftLoadingState(super.room);
}

class ChatRoomLoadedState extends ChatRoomBaseState {
  const ChatRoomLoadedState(super.room);
}

class ChatRoomErrorState extends ChatRoomBaseState {
  final String error;
  @override
  // TODO: implement props
  List<Object?> get props => [...super.room, error];
  const ChatRoomErrorState(this.error, super.room);
}
