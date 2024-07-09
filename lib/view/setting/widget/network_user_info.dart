import 'package:blca_project_app/injection.dart';
import 'package:blca_project_app/repo/authService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NetworkUserInfo extends StatelessWidget {
  final Widget Function(User) builder;

  const NetworkUserInfo({
    super.key,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      initialData: null,
      stream: Injection.get<AuthService>().authState(),
      builder: (_, snap) {
        print("connection state is ${snap.connectionState}");
        print("datat is ${snap.data}");
        final data = snap.data;
        if (data == null) return const SizedBox();
        return builder(data);
      },
    );
  }
}
