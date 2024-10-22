abstract class SendDataBaseState {
  const SendDataBaseState();
}

class SendDataInitialState extends SendDataBaseState {
  const SendDataInitialState();
}

class SendDataDeleteState extends SendDataBaseState {
  const SendDataDeleteState();
}

class SendDataLoadingState extends SendDataBaseState {
  const SendDataLoadingState();
}

class SendDataLoadedState extends SendDataBaseState {
  const SendDataLoadedState();
}

class SendDataErrorState extends SendDataBaseState {
  final String error;

  const SendDataErrorState(
    this.error,
  );
}
