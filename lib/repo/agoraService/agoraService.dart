import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:blca_project_app/logger.dart';
import 'package:permission_handler/permission_handler.dart';

Future requestPermission() async {
  List<Permission> requestPermission = [];
  if (!(await Permission.camera.request().isGranted)) {
    requestPermission.add(Permission.camera);
  }
  if (!(await Permission.microphone.request().isGranted)) {
    requestPermission.add(Permission.microphone);
  }
  if (requestPermission.isNotEmpty) {
    await requestPermission.request();
    return requestPermission;
  }
}

class AgoraHandler {
  void Function(RtcConnection connection, int elapsed) onJoinChannelSuccess;
  void Function(RtcConnection connection, int remoteUid, int elapsed)
      onUserJoined;
  void Function(
          RtcConnection connection, int remoteUid, UserOfflineReasonType reason)
      onUserOffline;
  void Function(RtcConnection connection, String token)
      onTokenPrivilegeWillExpire;
  void Function(RtcConnection, int) onRejoinChannelSuccess;
  void Function(RtcConnection, RtcStats) onLeaveChannel;
  void Function(ErrorCodeType, String) onError;

  AgoraHandler({
    required this.onJoinChannelSuccess,
    required this.onUserJoined,
    required this.onUserOffline,
    required this.onTokenPrivilegeWillExpire,
    required this.onRejoinChannelSuccess,
    required this.onLeaveChannel,
    required this.onError,
  });
  factory AgoraHandler.dummy() {
    return AgoraHandler(
      onJoinChannelSuccess: (_, __) {},
      onUserJoined: (_, __, ___) {},
      onUserOffline: (_, __, ___) {},
      onTokenPrivilegeWillExpire: (_, __) {},
      onRejoinChannelSuccess: (_, __) {},
      onLeaveChannel: (_, __) {},
      onError: (_, __) {},
    );
  }
}

const int _waiting = 0;

class AgoraService {
  final RtcEngine engine;
  AgoraService() : engine = createAgoraRtcEngine();
  final String appId = "1c8a52cd1d3e4532905229c9f2d85b7a";

//       //L
  int state = _waiting;
  get status => state;

  Future<void> init() async {
    assert(status == 0);
    await requestPermission();
    await engine.initialize(RtcEngineContext(appId: appId));
    state = 1;
  }

  RtcEngineEventHandler? _handler;
  set handler(AgoraHandler h) {
    _handler = RtcEngineEventHandler(
      //Live Start
      onUserJoined: (conn, remoteUid, _) {
        logger.i("[stream:onUserJoined] [conn] $conn\n[remoteUid] $remoteUid");
        // connection = AgoraLiveConnection(connection: conn, remoteId: remoteUid);
        // onLive.sink.add(connection);
        h.onUserJoined(conn, remoteUid, _);
      },
      //Live Stop

      onUserOffline: (conn, uid, reason) {
        logger.d(
            "[stream:onUserOffline] [conn] $conn\n[uid] $uid\n[reason] $reason");
        h.onUserOffline(conn, uid, reason);
      },
      //Live Stop

      onTokenPrivilegeWillExpire: (conn, token) {
        logger.d(
            "[stream:onTokenPrivilegeWillExpire] [conn] $conn\n[token] $token");
        h.onTokenPrivilegeWillExpire(conn, token);
      },

      ///View Count ++
      onJoinChannelSuccess: (conn, uid) {
        logger.i("[stream:onJoinChannelSuccess] [conn] $conn\n[uid] $uid");
        h.onJoinChannelSuccess(conn, uid);
      },

      ///View Count ++
      onRejoinChannelSuccess: (conn, _) {
        logger.i("[stream:onRejoinChannelSuccess] [conn] $conn");
        h.onRejoinChannelSuccess(conn, _);
      },

      ///View Count --
      onLeaveChannel: (conn, stats) {
        logger.i("[stream:onLeaveChannel] [conn] $conn\n[stats] $status");
        h.onLeaveChannel(conn, stats);
      },

      ///Ui
      onError: (code, str) {
        logger.e("[stream:onError] [code] $code\n[str] $str");
        h.onError(code, str);
      },
    );
  }

  Future<void> joinChannel(
    String token,
    String channel,
  ) async {
    assert(status == 2);
    await engine.joinChannel(
        token:
            "007eJxTYOhJFNjzau675gfH7Pfcy8hn3nA+W8Z158FZN1czarn/CDmvwGCYbJFoapScYphinGpiamxkaWBqZGSZbJlmlGJhmmSeeCJfJ70hkJGhvu4sEyMDBIL4XAwZGcXJGYl5eak5DAwAu9Ejrw==",
        channelId: "hhschannel",
        uid: 0,
        options: const ChannelMediaOptions());
  }

  Future<void> leaveChannel() async {
    assert(status == 2);
    await engine.leaveChannel();
  }

  Future<void> dispose() async {
    assert(status > 0);
    state = 0;

    await engine.leaveChannel();
    await engine.release();
  }

  Future<void> ready() async {
    assert(status == 1);
    engine.registerEventHandler(_handler!);
    await engine.enableAudio();
    await engine.enableVideo();
    state = 2;
  }
}
