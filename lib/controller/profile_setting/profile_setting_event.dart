abstract class ProfileSettingBaseEvent {
  const ProfileSettingBaseEvent();
}

class ProfileSettingUpdateName extends ProfileSettingBaseEvent {
  const ProfileSettingUpdateName();
}

class ProfileSettingUpdateEmail extends ProfileSettingBaseEvent {
  const ProfileSettingUpdateEmail();
}

class ProfileSettingUpdatePassword extends ProfileSettingBaseEvent {
  const ProfileSettingUpdatePassword();
}
