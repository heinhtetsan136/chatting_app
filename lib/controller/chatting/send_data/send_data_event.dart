abstract class SendDataBaseEvent {
  const SendDataBaseEvent();
}

class SendMessageEvent extends SendDataBaseEvent {
  const SendMessageEvent();
}

class SendPhotoEvent extends SendDataBaseEvent {
  const SendPhotoEvent();
}
