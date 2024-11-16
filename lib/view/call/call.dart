import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:blca_project_app/controller/videoCall/db_controller/video_call_db_blco.dart';
import 'package:blca_project_app/controller/videoCall/db_controller/video_call_db_event.dart';
import 'package:blca_project_app/controller/videoCall/videoCall_State.dart';
import 'package:blca_project_app/controller/videoCall/videoCall_bloc.dart';
import 'package:blca_project_app/logger.dart';
import 'package:blca_project_app/repo/agoraService/agoraService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:starlight_utils/starlight_utils.dart';

class Call extends StatelessWidget {
  const Call({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<AgoraVideocallBloc>();

    final videoCall = context.read<VideoCallDbBlco>();
    final agoraVideo = context.read<AgoraVideocallBloc>();
    return Scaffold(
      body: BlocConsumer<AgoraVideocallBloc, VideoCallState>(
          listener: (_, state) {
        if (state is VideoCallEndState) {
          videoCall.add(const VideoCallDbLeaveEvent());
          StarlightUtils.pop();
        }
      }, builder: (_, state) {
        if (state is VideocallLoadingState) {
          return SizedBox(
            width: context.width,
            height: context.height,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        return Column(
          children: [
            const localView(),
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: StreamBuilder(
                        stream: agoraVideo.connectStream,
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
                          print(
                              "[stream:onUserJoined] uid is ${snapshot.data?.remoteId}");
                          print(
                              "[stream:onUserJoined] louid is ${snapshot.data?.connection.localUid}");
                          return remoteView(
                            conn: snapshot.data!,
                          );
                        }),
                  ),
                  Positioned(top: 20, child: Text("$state")),
                  const Positioned(
                    right: 20,
                    top: 40,
                    child: localView(),
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
                              videoCall.add(const VideoCallDbLeaveEvent());
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
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}

class remoteView extends StatelessWidget {
  remoteView({super.key, required this.conn});
  AgoraLiveConnection conn;

  @override
  Widget build(BuildContext context) {
    final agoraVideo = context.read<AgoraVideocallBloc>();
    return AgoraVideoView(
        key: UniqueKey(),
        controller: VideoViewController.remote(
            canvas: VideoCanvas(uid: conn.remoteId),
            rtcEngine: agoraVideo.engine,
            connection: conn.connection
            // connection: const RtcConnection(
            //     localUid: 0,
            //     channelId:
            //         "007eJxTYOhJFNjzau675gfH7Pfcy8hn3nA+W8Z158FZN1czarn/CDmvwGCYbJFoapScYphinGpiamxkaWBqZGSZbJlmlGJhmmSeeCJfJ70hkJGhvu4sEyMDBIL4XAwZGcXJGYl5eak5DAwAu9Ejrw=="),
            ));
  }
}

class localView extends StatelessWidget {
  const localView({super.key});

  @override
  Widget build(BuildContext context) {
    final agoraVideo = context.read<AgoraVideocallBloc>();
    return Container(
      width: 300,
      height: 200,
      color: Colors.blue,
      child: AgoraVideoView(
        onAgoraVideoViewCreated: (controller) {
          logger.i("this is AgLocal $controller");
        },
        controller: VideoViewController(
            rtcEngine: agoraVideo.engine,
            canvas: const VideoCanvas(
                uid: 0,
                renderMode: RenderModeType.renderModeFit,
                enableAlphaMask: true,
                sourceType: VideoSourceType.videoSourceCamera,
                mirrorMode: VideoMirrorModeType.videoMirrorModeEnabled)),
      ),
    );
  }
}
