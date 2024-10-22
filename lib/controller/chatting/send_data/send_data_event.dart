import 'package:blca_project_app/repo/message.dart';

abstract class SendDataBaseEvent {
  const SendDataBaseEvent();
}

class SendMessageEvent extends SendDataBaseEvent {
  const SendMessageEvent();
}

class SendPhotoEvent extends SendDataBaseEvent {
  const SendPhotoEvent();
}

class UpdateMessageEvent extends SendDataBaseEvent {
  final String id;

  const UpdateMessageEvent(
    this.id,
  );
}

class DeleteEvent extends SendDataBaseEvent {
  Message message;
  DeleteEvent({required this.message});
}
