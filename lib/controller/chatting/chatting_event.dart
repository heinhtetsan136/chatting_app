import 'package:blca_project_app/repo/message.dart';

abstract class ChattingEvent {
  const ChattingEvent();
}

class ChattingGetAllMessageEvent extends ChattingEvent {
  const ChattingGetAllMessageEvent();
}

class ChattingRefreshMessageEvent extends ChattingEvent {
  const ChattingRefreshMessageEvent();
}

class ChattingNewMessageEvent extends ChattingEvent {
  final List<Message> post;
  ChattingNewMessageEvent(this.post);
}

class DeleteEvent extends ChattingEvent {
  String messageId;
  DeleteEvent({required this.messageId});
}
