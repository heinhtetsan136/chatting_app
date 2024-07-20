import 'package:blca_project_app/repo/user_model.dart';

abstract class ChatRoomCreateEvent {
  const ChatRoomCreateEvent();
}

class ChatRoomOnCreateEvent extends ChatRoomCreateEvent {
  final ContactUser other;
  const ChatRoomOnCreateEvent(this.other);
}
