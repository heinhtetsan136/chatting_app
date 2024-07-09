import 'package:blca_project_app/route/route.dart';
import 'package:flutter/material.dart';
import 'package:starlight_utils/starlight_utils.dart';

class PostScreen extends StatelessWidget {
  const PostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                StarlightUtils.pushNamed(RouteNames.settingPage);
              },
              icon: const Icon(Icons.settings))
        ],
      ),
    );
  }
}
