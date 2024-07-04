abstract class RegisterBaseState {
  const RegisterBaseState();
}

class RegisterInitialState extends RegisterBaseState {
  const RegisterInitialState();
}

class RegisterLoadingState extends RegisterBaseState {
  const RegisterLoadingState();
}

class RegisterSuccessState extends RegisterBaseState {
  const RegisterSuccessState();
}

class RegisterFailedState extends RegisterBaseState {
  final String message;
  const RegisterFailedState(this.message);
}
