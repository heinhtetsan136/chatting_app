abstract class ProfileSettingBaseEvent {
  const ProfileSettingBaseEvent();
}

class ProfileSettingUpdateName extends ProfileSettingBaseEvent {
  const ProfileSettingUpdateName();
}

class ProfileSetttingUploadPhoto extends ProfileSettingBaseEvent {
  const ProfileSetttingUploadPhoto();
}

class ProfileSettingUpdateEmail extends ProfileSettingBaseEvent {
  const ProfileSettingUpdateEmail();
}

class ProfileSettingUpdatePassword extends ProfileSettingBaseEvent {
  const ProfileSettingUpdatePassword();
}

class UserChangeEvent extends ProfileSettingBaseEvent {
  const UserChangeEvent();
}

class SignoutEvent extends ProfileSettingBaseEvent {
  const SignoutEvent();
}
