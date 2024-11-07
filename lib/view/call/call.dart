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
          Positioned(
            right: 20,
            top: 40,
            height: 150,
            width: 150,
            child: AgoraVideoView(
              controller: VideoViewController(
                  rtcEngine: agora.engine, canvas: const VideoCanvas(uid: 0)),
            ),
          ),
          Positioned.fill(
            child: AgoraVideoView(
                controller: VideoViewController.remote(
              canvas: const VideoCanvas(uid: 0),
              rtcEngine: agora.engine,
              connection: const RtcConnection(
                  channelId:
                      "007eJxTYOhJFNjzau675gfH7Pfcy8hn3nA+W8Z158FZN1czarn/CDmvwGCYbJFoapScYphinGpiamxkaWBqZGSZbJlmlGJhmmSeeCJfJ70hkJGhvu4sEyMDBIL4XAwZGcXJGYl5eak5DAwAu9Ejrw=="),
            )),
          ),
        ],
      ),
    );
  }
}
