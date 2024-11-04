import 'package:blca_project_app/view/setting/widget/network_user_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileSettingCard extends StatelessWidget {
  final void Function()? onTap;
  final String title;
  final String Function(User) value;
  const ProfileSettingCard(
      {super.key, this.onTap, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      onTap: onTap,
      title: Text(title),
      trailing: NetworkUserInfo(builder: (data) {
        return Text(
          value(data),
        );
      }),
    );
  }
}
