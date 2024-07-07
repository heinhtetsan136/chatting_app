abstract class ProfileSettingState {
  const ProfileSettingState();
}

class ProfileSettingInitialState extends ProfileSettingState {
  const ProfileSettingInitialState();
}

class ProfileSettingLoadingState extends ProfileSettingState {
  const ProfileSettingLoadingState();
}

class ProfileSettingSuccessState extends ProfileSettingState {
  const ProfileSettingSuccessState();
}

class ProfileSettingErrorState extends ProfileSettingState {
  final String message;
  const ProfileSettingErrorState(this.message);
}