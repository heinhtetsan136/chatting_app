import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:blca_project_app/controller/videoCall/videoCall_Event.dart';
import 'package:blca_project_app/controller/videoCall/videoCall_bloc.dart';
import 'package:blca_project_app/injection.dart';
import 'package:blca_project_app/repo/agoraService/agoraService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:starlight_utils/starlight_utils.dart';

class Call extends StatelessWidget {
  const Call({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<AgoraVideocallBloc>();
    final agora = Injection<AgoraService>();
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: StreamBuilder(
                stream: agora.remotId,
                builder: (context, snapshot) {
                  print(snapshot.data);
                  if (snapshot.data == null) {
                    return const SizedBox(
                      child: Center(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                          Text("Calling...")
                        ],
                      )),
                    );
                  }

                  return AgoraVideoView(
                      key: UniqueKey(),
                      controller: VideoViewController.remote(
                          canvas: VideoCanvas(uid: snapshot.data!.remoteId),
                          rtcEngine: agora.engine,
                          connection: snapshot.data!.connection
                          // connection: const RtcConnection(
                          //     localUid: 0,
                          //     channelId:
                          //         "007eJxTYOhJFNjzau675gfH7Pfcy8hn3nA+W8Z158FZN1czarn/CDmvwGCYbJFoapScYphinGpiamxkaWBqZGSZbJlmlGJhmmSeeCJfJ70hkJGhvu4sEyMDBIL4XAwZGcXJGYl5eak5DAwAu9Ejrw=="),
                          ));
                }),
          ),
          Positioned(
            right: 20,
            top: 40,
            height: 150,
            width: 150,
            child: Container(
              child: AgoraVideoView(
                controller: VideoViewController(
                    rtcEngine: agora.engine, canvas: const VideoCanvas(uid: 0)),
              ),
            ),
          ),
          Positioned(
            bottom: 100,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.camera_alt_outlined,
                        size: 50,
                      )),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.mic_off_outlined,
                      size: 50,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      bloc.add(const VideocallEndEvent());
                      StarlightUtils.pop();
                    },
                    icon: const Icon(
                      color: Colors.red,
                      Icons.call_end,
                      size: 50,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
