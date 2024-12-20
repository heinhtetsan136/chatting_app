import 'package:blca_project_app/controller/login/login_bloc.dart';
import 'package:blca_project_app/controller/theme/theme_cubit.dart';
import 'package:blca_project_app/injection.dart';
import 'package:blca_project_app/repo/authService.dart';
import 'package:blca_project_app/route/route.dart';
import 'package:blca_project_app/view/auth/login_page.dart';
import 'package:blca_project_app/view/setting/widget/profile_card.dart';
import 'package:blca_project_app/view/setting/widget/switch_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:starlight_utils/starlight_utils.dart';
import 'package:url_launcher/url_launcher.dart';

void _aboutUs() {
  StarlightUtils.aboutDialog(
    applicationName: "Chatting App",
    applicationVersion: "version 1.0.0",
  );
}

void _contactUs() {
  launchUrl(Uri.parse("tel:+959794810715"));
}

void _termsAndConditions() {
  launchUrl(Uri.parse("https://google.com"));
}

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: SizedBox(
        width: context.width,
        height: context.height,
        child: ListView(
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          children: [
            StreamBuilder(
                initialData: null,
                stream: Injection.get<AuthService>().authState(),
                builder: (_, snap) {
                  if (snap.connectionState == ConnectionState.waiting) {
                    return const SizedBox(
                        height: 100,
                        width: 100,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ));
                  }
                  print("connection state is ${snap.connectionState}");
                  final data = snap.data;
                  print("data is $data");
                  final profileUrl = data?.photoURL;
                  if (data == null) return const SizedBox();
                  return GestureDetector(
                    onTap: () {
                      StarlightUtils.pushNamed(RouteNames.profile);
                    },
                    child: ProfileCard(
                        profileUrl: profileUrl ?? "",
                        shortName: data.email?[0] ??
                            data.displayName?[0] ??
                            data.uid[0],
                        displayName: data.displayName ?? "NA",
                        email: data.email!),
                  );
                }),
            BlocBuilder<ThemeCubit, ThemeMode>(builder: (context, state) {
              return SwitchCard(
                onTap: (value) {
                  context.read<ThemeCubit>().toggleTheme();
                },
                title: "Theme",
                current: state == ThemeMode.light ? "light" : "dark",
                first: "light",
                second: "dark",
                firstWidget: const Icon(Icons.brightness_5),
                secondWidget: const Icon(Icons.brightness_2),
              );
            }),
            const OnTapCard(
              onTap: _termsAndConditions,
              title: "Terms and Conditions",
            ),
            OnTapCard(
              onTap: () {
                StarlightUtils.push(
                  const LicensePage(),
                );
              },
              title: "Licenses",
            ),
            const OnTapCard(
              onTap: _contactUs,
              title: "Contact Us",
            ),
            const OnTapCard(
              onTap: _aboutUs,
              title: "About Us",
            ),
            const Padding(
                padding: EdgeInsets.only(top: 20),
                child: Align(
                  child: LogoutButton(),
                )),
          ],
        ),
      ),
    );
  }
}

Future<void> _logout() async {
  await Injection<AuthService>().signOut();
  StarlightUtils.pushAndRemoveUntil(
      BlocProvider(
        create: (_) => LoginBloc(),
        child: const LoginPage(),
      ), (Route route) {
    return false;
  });
}

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return const TextButton(
      onPressed: _logout,
      child: Text(
        "Logout",
      ),
    );
  }
}

class OnTapCard extends StatelessWidget {
  final String title;

  final void Function()? onTap;

  const OnTapCard({
    super.key,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
        child: ListTile(
          onTap: onTap,
          title: Text(
            title,
          ),
        ));
  }
}
