import 'dart:async';

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
  StreamSubscription? _authstate;

  ProfileSettingBloc() : super(const ProfileSettingInitialState()) {
    on<ProfileSettingUpdateName>((event, emit) async {
      _authstate = _authService.authState().listen((user) {
        if (user == null) {
          add(const SignoutEvent());
        } else {
          add(const UserChangeEvent());
        }
      });

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
        emit(ProfileSettingErrorState(result.error!.message.toString()));
        return;
      }

      emit(const ProfileSettingSuccessState());
    });
    on<ProfileSetttingUploadPhoto>((event, emit) async {
      emit(const ProfileSettingUploadingPhotoState());
      final result = await _authService.uploadImage();
      if (result.hasError) {
        emit(ProfileSettingErrorState(result.error!.message.toString()));
        return;
      }
      emit(const ProfileSettingSuccessState());
    });
    on<SignoutEvent>((_, emit) {
      _authService.signOut();
      emit(const ProfileSettingSignoutState());
    });
    on<UserChangeEvent>((_, emit) {
      emit(const ProfileSettingUserChangeState());
    });
    on<ProfileSettingUpdatePassword>((event, emit) async {
      emit(const ProfileSettingLoadingState());
      final result =
          await _authService.updatePassword(data.text, password.text);
      if (result.hasError) {
        emit(ProfileSettingErrorState(result.error!.message.toString()));
        return;
      }
      emit(const ProfileSettingSuccessState());
    });
  }

  @override
  Future<void> close() {
    print("Close on bloc");
    data.dispose();
    _authService.dispose();
    password.dispose();

    // TODO: implement close
    return super.close();
  }
}
