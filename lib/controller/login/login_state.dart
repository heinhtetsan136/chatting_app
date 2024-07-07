abstract class LoginBaseState {
  const LoginBaseState();
}

class LoginInitial extends LoginBaseState {
  const LoginInitial();
}

class LoginLoading extends LoginBaseState {
  const LoginLoading();
}

class LoginSuccess extends LoginBaseState {
  const LoginSuccess();
}

class LoginFailed extends LoginBaseState {
  final String message;
  const LoginFailed(this.message);
}
