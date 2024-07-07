import 'package:blca_project_app/controller/login/login_event.dart';
import 'package:blca_project_app/controller/login/login_state.dart';
import 'package:blca_project_app/injection.dart';
import 'package:blca_project_app/repo/authService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginBloc extends Bloc<LoginEvent, LoginBaseState> {
  final AuthService _authService = Injection.get<AuthService>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();
  final ValueNotifier<bool> passwordIsShow = ValueNotifier(false);
  GlobalKey<FormState>? formKey = GlobalKey<FormState>();
  LoginBloc() : super(const LoginInitial()) {
    on<OnLogin>((event, emit) async {
      if (formKey?.currentState?.validate() != true || state is LoginLoading) {
        return;
      }
      emit(const LoginLoading());
      final user = await _authService.login(
        emailController.text,
        passwordController.text,
      );
      if (user.hasError) {
        emit(LoginFailed(user.error!.message));
        return;
      }
      emit(const LoginSuccess());
    });
  }

  void showPassword() {
    passwordIsShow.value = !passwordIsShow.value;
  }

  @override
  Future<void> close() {
    emailController.clear();
    passwordController.clear();
    emailFocusNode.unfocus();
    passwordFocusNode.unfocus();
    passwordIsShow.value = false;
    formKey = null;
    // TODO: implement close
    return super.close();
  }
}
