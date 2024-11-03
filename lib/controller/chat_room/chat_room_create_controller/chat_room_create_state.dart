import 'package:blca_project_app/repo/chatRoom_model.dart';

abstract class ChatRoomCreateState {
  const ChatRoomCreateState();
}

class ChatRoomCreateInitialState extends ChatRoomCreateState {
  const ChatRoomCreateInitialState();
}

class ChatRoomCreateLoadingState extends ChatRoomCreateState {
  const ChatRoomCreateLoadingState();
}

class ChatRoomCreateSuccessState extends ChatRoomCreateState {
  final ChatRoom room;
  const ChatRoomCreateSuccessState(this.room);
}

class ChatRoomDeletedState extends ChatRoomCreateState {
  const ChatRoomDeletedState();
}

class ChatRoomCreateErrorState extends ChatRoomCreateState {
  final String error;
  const ChatRoomCreateErrorState(
    this.error,
  );
}
