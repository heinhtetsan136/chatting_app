import 'package:blca_project_app/repo/message.dart';

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
  final List<Messages> post;
  NewMessageEvent(this.post);
}
