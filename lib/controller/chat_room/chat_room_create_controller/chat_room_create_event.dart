import 'package:blca_project_app/repo/chatRoom_model.dart';
import 'package:blca_project_app/repo/user_model.dart';

abstract class ChatRoomCreateEvent {
  const ChatRoomCreateEvent();
}

class ChatRoomOnCreateEvent extends ChatRoomCreateEvent {
  final ContactUser room;
  const ChatRoomOnCreateEvent(this.room);
}

class ChatRoomDeleteEvent extends ChatRoomCreateEvent {
  final ChatRoom room;
  ChatRoomDeleteEvent(this.room);
}
