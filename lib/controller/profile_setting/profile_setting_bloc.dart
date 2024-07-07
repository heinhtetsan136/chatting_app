import 'package:blca_project_app/controller/profile_setting/profile_setting_event.dart';
import 'package:blca_project_app/controller/profile_setting/profile_setting_state.dart';
import 'package:blca_project_app/injection.dart';
import 'package:blca_project_app/repo/authService.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileSettingBloc
    extends Bloc<ProfileSettingBaseEvent, ProfileSettingState> {
  final TextEditingController data = TextEditingController();

  final AuthService _authService = Injection.get<AuthService>();
  final TextEditingController password = TextEditingController();

  ProfileSettingBloc() : super(const ProfileSettingInitialState()) {
    on<ProfileSettingUpdateName>((event, emit) async {
      emit(const ProfileSettingLoadingState());
      final result = await _authService.updateUserName(data.text);
      if (result.hasError) {
        emit(ProfileSettingErrorState(result.error.toString()));
        return;
      }
      emit(const ProfileSettingSuccessState());
    });
    on<ProfileSettingUpdateEmail>((event, emit) async {
      emit(const ProfileSettingLoadingState());
      final result = await _authService.updateEmail(data.text, password.text);
      if (result.hasError) {
        emit(ProfileSettingErrorState(result.error.toString()));
        return;
      }
      emit(const ProfileSettingSuccessState());
    });
    on<ProfileSettingUpdatePassword>((event, emit) async {
      emit(const ProfileSettingLoadingState());
      final result =
          await _authService.updatePassword(data.text, password.text);
      if (result.hasError) {
        emit(ProfileSettingErrorState(result.error.toString()));
        return;
      }
      emit(const ProfileSettingSuccessState());
    });
  }

  @override
  Future<void> close() {
    data.dispose();

    password.dispose();

    // TODO: implement close
    return super.close();
  }
}
