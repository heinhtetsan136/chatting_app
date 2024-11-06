import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:blca_project_app/injection.dart';
import 'package:blca_project_app/repo/agoraService/agoraService.dart';
import 'package:flutter/material.dart';

class Call extends StatelessWidget {
  const Call({super.key});

  @override
  Widget build(BuildContext context) {
    final agora = Injection<AgoraService>();
    return Scaffold(
      body: Stack(
        children: [
          AgoraVideoView(
              controller: VideoViewController(
                  rtcEngine: agora.engine, canvas: const VideoCanvas(uid: 0))),
        ],
      ),
    );
  }
}
