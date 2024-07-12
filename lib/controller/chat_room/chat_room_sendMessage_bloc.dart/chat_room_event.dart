import 'package:blca_project_app/repo/chatRoom_model.dart';

abstract class ChatRoomBaseEvent {
  const ChatRoomBaseEvent();
}

class GetMessageEvent extends ChatRoomBaseEvent {
  GetMessageEvent();
}

class RefreshMessageEvent extends ChatRoomBaseEvent {
  RefreshMessageEvent();
}

class NewMessageEvent extends ChatRoomBaseEvent {
  final List<ChatRoom> post;
  NewMessageEvent(this.post);
}
