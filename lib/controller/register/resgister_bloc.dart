import 'package:blca_project_app/controller/register/register_event.dart';
import 'package:blca_project_app/controller/register/register_state.dart';
import 'package:blca_project_app/injection.dart';
import 'package:blca_project_app/repo/authService.dart';
import 'package:blca_project_app/repo/firestoreService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ResgisterBloc extends Bloc<RegisterBaseEvent, RegisterBaseState> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController comfirmPasswordController =
      TextEditingController();
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode comfirmPasswordFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();
  final ValueNotifier<bool> passwordIsShow = ValueNotifier(true);
  final ValueNotifier<bool> comfirmpasswordIsShow = ValueNotifier(true);
  final ContactUserService db = Injection.get<ContactUserService>();
  GlobalKey<FormState>? form = GlobalKey<FormState>();
  final _auth = Injection.get<AuthService>();
  ResgisterBloc(super.initialState) {
    on<OnRegisterEvent>((_, emit) async {
      if (state is RegisterLoadingState ||
          form?.currentState?.validate() != true) return;
      emit(const RegisterLoadingState());
      final user =
          await _auth.signIn(emailController.text, passwordController.text);
      if (user.hasError) {
        emit(RegisterFailedState(user.error!.message));
        return;
      }
      await db.createUser(user.data!);
      emit(const RegisterSuccessState());
    });
  }
  void showPassword() {
    passwordIsShow.value = !passwordIsShow.value;
  }

  void showComfirmPassword() {
    comfirmpasswordIsShow.value = !comfirmpasswordIsShow.value;
  }

  @override
  Future<void> close() {
    passwordIsShow.dispose();
    comfirmpasswordIsShow.dispose();
    comfirmPasswordController.dispose();
    emailController.dispose();
    passwordController.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    comfirmPasswordFocusNode.dispose();
    form = null;
    // TODO: implement close
    return super.close();
  }
}
