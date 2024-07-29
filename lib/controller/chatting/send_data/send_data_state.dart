import 'package:blca_project_app/repo/message.dart';

abstract class SendDataBaseState {
  const SendDataBaseState();
}

class SendDataInitialState extends SendDataBaseState {
  const SendDataInitialState();
}

class SendDataLoadingState extends SendDataBaseState {
  final Message data;
  const SendDataLoadingState(this.data);
}

class SendDataLoadedState extends SendDataBaseState {
  final Message data;
  const SendDataLoadedState(this.data);
}

class SendDataErrorState extends SendDataBaseState {
  final String error;
  final Message data;
  const SendDataErrorState(this.error, this.data);
}
