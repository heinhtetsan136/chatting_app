import 'package:blca_project_app/controller/profile_setting/profile_setting_bloc.dart';
import 'package:blca_project_app/route/route.dart';
import 'package:blca_project_app/view/setting/widget/network_profile.dart';
import 'package:blca_project_app/view/setting/widget/network_user_info.dart';
import 'package:blca_project_app/view/setting/widget/profile_setting_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:starlight_utils/starlight_utils.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final profilesettingcubit = context.read<ProfileSettingBloc>();
    return Scaffold(
        appBar: AppBar(
          title: const Text("Update Profile"),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              width: context.width,
              height: context.height * 0.3,
              decoration: BoxDecoration(
                color: Colors.greenAccent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      const CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.blue,
                      ),
                      NetworkUserInfo(builder: (data) {
                        final shortName = data.email?[0] ?? data.uid[0];
                        // final shortName = data.displayName?[0] ??
                        //     data.email?[0] ??
                        //     data.uid[0];
                        final profileUrl = data.photoURL ?? "";
                        if (profileUrl.isEmpty == true) {
                          return CircleAvatar(
                            maxRadius: 48,
                            child: Text(
                              shortName,
                              style: const TextStyle(
                                fontSize: 28,
                              ),
                            ),
                          );
                        }
                        return NetworkProfile(
                          radius: 42,
                          profileUrl: profileUrl,
                          onFail: CircleAvatar(
                            maxRadius: 42,
                            child: Text(
                              shortName,
                              style: const TextStyle(
                                fontSize: 28,
                              ),
                            ),
                          ),
                        );
                      }),
                      const Positioned(
                        bottom: 5,
                        child: Icon(
                          Icons.camera_alt_rounded,
                          size: 18,
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: NetworkUserInfo(
                      builder: (user) {
                        return Text(
                          user.displayName?.isNotEmpty == true
                              ? user.displayName!
                              : user.email?.isNotEmpty == true
                                  ? user.email!
                                  : "Anonymous",
                          style: const TextStyle(
                            fontSize: 20,
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: NetworkUserInfo(
                      builder: (user) {
                        return Text(
                          "Identity: ${user.providerData.first.email ?? user.providerData.first.phoneNumber ?? user.email ?? "NA"}",
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: NetworkUserInfo(
                      builder: (user) {
                        return Text(
                          "Linked With: ${user.providerData.first.providerId}",
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            ProfileSettingCard(
                onTap: () async {
                  StarlightUtils.pushNamed(RouteNames.updateUserName,
                      arguments: profilesettingcubit);
                },
                title: "Display Name",
                value: (user) {
                  return user.displayName?.isNotEmpty == true
                      ? user.displayName!
                      : user.email?.isNotEmpty == true
                          ? user.email!
                          : "Anonymous";
                }),
            ProfileSettingCard(
                onTap: () async {
                  StarlightUtils.pushNamed(RouteNames.updateEmail,
                      arguments: ProfileSettingBloc());
                },
                title: "Identity",
                value: (user) {
                  return user.providerData.first.email ??
                      user.providerData.first.phoneNumber ??
                      user.email ??
                      "NA";
                }),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: ProfileSettingCard(
                title: "Linked With",
                value: (user) {
                  return user.providerData.first.providerId;
                },
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  StarlightUtils.pushNamed(RouteNames.updatePassword,
                      arguments: ProfileSettingBloc());
                },
                child: const Text("Change Password"))
          ],
        ));
  }
}
