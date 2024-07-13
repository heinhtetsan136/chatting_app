import 'package:blca_project_app/repo/chatRoom_model.dart';

abstract class ChatRoomBaseEvent {
  const ChatRoomBaseEvent();
}

class GetChatRoomEvent extends ChatRoomBaseEvent {
  GetChatRoomEvent();
}

class RefreshChatRoomEvent extends ChatRoomBaseEvent {
  RefreshChatRoomEvent();
}

class NewChatRoomEvent extends ChatRoomBaseEvent {
  final List<ChatRoom> post;
  NewChatRoomEvent(this.post);
}
