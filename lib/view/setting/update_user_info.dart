import 'package:blca_project_app/controller/profile_setting/profile_setting_bloc.dart';
import 'package:blca_project_app/controller/profile_setting/profile_setting_event.dart';
import 'package:blca_project_app/controller/profile_setting/profile_setting_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:starlight_utils/starlight_utils.dart';

class UpdateUserInfo extends StatelessWidget {
  final bool? isChangeEmail;
  const UpdateUserInfo({super.key, this.isChangeEmail});

  @override
  Widget build(BuildContext context) {
    final profilesettingbloc = context.read<ProfileSettingBloc>();
    return Scaffold(
      appBar: AppBar(
        title: Text(isChangeEmail == null
            ? "Name is Required"
            : isChangeEmail == true
                ? "Email is Required"
                : "PassWord is Required"),
      ),
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: profilesettingbloc.data,
              validator: (value) {
                return value?.isNotEmpty == true
                    ? null
                    : isChangeEmail == null
                        ? "Name is Required"
                        : isChangeEmail == true
                            ? "Email is Required"
                            : "PassWord is Required";
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,

              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText: isChangeEmail == null
                    ? "Display Name "
                    : isChangeEmail == true
                        ? "New Email"
                        : "New PassWord ",
              ),
              // onFieldSubmitted: (value) {
              //   if (value.isNotEmpty) {
              //     StarlightUtils.pop(result: value);
              //   }
              // },
            ),
            isChangeEmail == null
                ? const SizedBox()
                : Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: TextFormField(
                      controller: profilesettingbloc.password,
                      validator: (value) {
                        return value?.isNotEmpty == true
                            ? null
                            : "PassWord is Required";
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,

                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        hintText: isChangeEmail! == true
                            ? "Type your password"
                            : "Old PassWord ",
                      ),
                      // onFieldSubmitted: (value) {
                      //   if (value.isNotEmpty) {
                      //     StarlightUtils.pop(result: value);
                      //   }
                      // },
                    ),
                  ),
            Container(
              padding: const EdgeInsets.only(top: 20),
              width: context.width,
              child: ElevatedButton(
                  onPressed: () {
                    final event = isChangeEmail == null
                        ? const ProfileSettingUpdateName()
                        : isChangeEmail == true
                            ? const ProfileSettingUpdateEmail()
                            : const ProfileSettingUpdateEmail();
                    print("event is $event");
                    profilesettingbloc.add(event);
                  },
                  child: BlocConsumer<ProfileSettingBloc, ProfileSettingState>(
                      builder: (_, state) {
                    if (state is ProfileSettingLoadingState) {
                      return const Center(child: CupertinoActivityIndicator());
                    }
                    return const Text("Update Name");
                  }, listener: (_, state) {
                    if (state is ProfileSettingSuccessState) {
                      StarlightUtils.pop();
                    }
                    if (state is ProfileSettingErrorState) {
                      StarlightUtils.snackbar(
                          SnackBar(content: Text(state.message)));
                    }
                  })),
            )
          ],
        ),
      ),
    );
  }
}
