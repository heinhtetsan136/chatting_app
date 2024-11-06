# blca_project_app

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.




// import 'dart:async';

// import 'package:agora_rtc_engine/agora_rtc_engine.dart';
// import 'package:logger/logger.dart';
// import 'package:permission_handler/permission_handler.dart';



// Future requestPermission() async {
//   final List<Permission> requiredPermissions = [];

//   if (!(await Permission.camera.isGranted)) {
//     requiredPermissions.add(Permission.camera);
//   }

//   if (!(await Permission.microphone.isGranted)) {
//     requiredPermissions.add(Permission.microphone);
//   }

//   if (requiredPermissions.isNotEmpty) {
//     await requiredPermissions.request();
//     return requestPermission();
//   }
// }

// class AgoraHandler {
//   void Function(RtcConnection connection, int elapsed) onJoinChannelSuccess;
//   void Function(RtcConnection connection, int remoteUid, int elapsed)
//       onUserJoined;
//   void Function(
//           RtcConnection connection, int remoteUid, UserOfflineReasonType reason)
//       onUserOffline;
//   void Function(RtcConnection connection, String token)
//       onTokenPrivilegeWillExpire;
//   void Function(RtcConnection, int) onRejoinChannelSuccess;
//   void Function(RtcConnection, RtcStats) onLeaveChannel;
//   void Function(ErrorCodeType, String) onError;

//   AgoraHandler({
//     required this.onJoinChannelSuccess,
//     required this.onUserJoined,
//     required this.onUserOffline,
//     required this.onTokenPrivilegeWillExpire,
//     required this.onRejoinChannelSuccess,
//     required this.onLeaveChannel,
//     required this.onError,
//   });

//   factory AgoraHandler.dummy() {
//     return AgoraHandler(
//       onJoinChannelSuccess: (_, __) {},
//       onUserJoined: (_, __, ___) {},
//       onUserOffline: (_, __, ___) {},
//       onTokenPrivilegeWillExpire: (_, __) {},
//       onRejoinChannelSuccess: (_, __) {},
//       onLeaveChannel: (_, __) {},
//       onError: (_, __) {},
//     );
//   }
// }

// const int _waiting = 0;

// ///Guest user
// class AgoraLiveConnection {
//   final RtcConnection connection;
//   final int remoteId; //host user id

//   const AgoraLiveConnection({
//     required this.connection,
//     required this.remoteId,
//   });
// }

// abstract class AgoraBaseService {
//   final RtcEngine engine;
//   final Logger _logger;
  

//   AgoraBaseService()
//       : _logger = Logger(),
       
//         engine = createAgoraRtcEngine();

//   String get appId;

//   ClientRoleType get role;

//   ChannelProfileType get channelProfile;

//   VideoViewController get videoViewController;

//   int _state = _waiting;

//   int get status => _state;

//   /// assert(0)
//   Future<void> init() async {
//     assert(status == 0);
//     await requestPermission();
//     await engine.initialize(
//       RtcEngineContext(
//         appId: appId,
//         channelProfile: channelProfile,
//         logConfig: const LogConfig(
//           level: LogLevel.logLevelFatal,
//         ),
//       ),
//     );
//     _state = 1;
//   }

//   RtcEngineEventHandler? _handler;

//   bool _withSound = true;
//   final StreamController<bool> _audioMode = StreamController.broadcast();

//   Stream<bool> get audioMode => _audioMode.stream;

//   ///  assert(1)
//   Future<void> ready() async {
//     assert(status == 1 && _handler != null);
//     engine.registerEventHandler(_handler!);
//     await engine.setClientRole(role: role);
  
//     await engine.enableVideo();
//     if (role == ClientRoleType.clientRoleAudience) {
//       _withSound = setting.withSound;
//       await audio();
//     }
//     _state = 2;
//   }

//   Future<void> audio() async {
//     _audioMode.sink.add(_withSound);
//     if (_withSound) {
//       await engine.enableAudio();
//     } else {
//       await engine.disableAudio();
//     }
//   }

//   Future<void> audioToggle() async {
//     _withSound = !_withSound;
//     await audio();
//   }

//   String? channel;

//   /// assert(2)
//   Future<void> live(
//     String token,
//     String channel,
//     int uid, [
//     ChannelMediaOptions? options,
//   ]) async {
//     assert(_state == 2);
//     this.channel = channel;
//     await engine.joinChannel(
//       token: token,
//       channelId: channel,
//       uid: uid,
//       options: options ??
//           ChannelMediaOptions(
//             token: token,
//           ),
//     );
//   }

//   /// assert(1)
//   Future<void> close() async {
//     assert(status > 0);
//     _state = 0;
//     _withSound = true;
//     engine.unregisterEventHandler(_handler!);
//     await engine.leaveChannel();
//     await engine.release();
//   }

//   Future<void> dispose() async {
//     await _audioMode.close();
//   }

//   AgoraLiveConnection? connection;

//   StreamController<AgoraLiveConnection?> onLive =
//       StreamController<AgoraLiveConnection?>.broadcast();

//   set handler(AgoraHandler h) {
//     _handler = RtcEngineEventHandler(
//       //Live Start
//       onUserJoined: (conn, remoteUid, _) {
//         _logger.i("[stream:onUserJoined] [conn] $conn\n[remoteUid] $remoteUid");
//         connection = AgoraLiveConnection(connection: conn, remoteId: remoteUid);
//         onLive.sink.add(connection);
//         h.onUserJoined(conn, remoteUid, _);
//       },
//       //Live Stop

//       onUserOffline: (conn, uid, reason) {
//         _logger.d(
//             "[stream:onUserOffline] [conn] $conn\n[uid] $uid\n[reason] $reason");
//         h.onUserOffline(conn, uid, reason);
//       },
//       //Live Stop

//       onTokenPrivilegeWillExpire: (conn, token) {
//         _logger.d(
//             "[stream:onTokenPrivilegeWillExpire] [conn] $conn\n[token] $token");
//         h.onTokenPrivilegeWillExpire(conn, token);
//       },

//       ///View Count ++
//       onJoinChannelSuccess: (conn, uid) {
//         _logger.i("[stream:onJoinChannelSuccess] [conn] $conn\n[uid] $uid");
//         h.onJoinChannelSuccess(conn, uid);
//       },

//       ///View Count ++
//       onRejoinChannelSuccess: (conn, _) {
//         _logger.i("[stream:onRejoinChannelSuccess] [conn] $conn");
//         h.onRejoinChannelSuccess(conn, _);
//       },

//       ///View Count --
//       onLeaveChannel: (conn, stats) {
//         _logger.i("[stream:onLeaveChannel] [conn] $conn\n[stats] $status");
//         h.onLeaveChannel(conn, stats);
//       },

//       ///Ui
//       onError: (code, str) {
//         _logger.e("[stream:onError] [code] $code\n[str] $str");
//         h.onError(code, str);
//       },
//     );
//   }
// }

// ///
// ///  Backend (Go)
// ///
// ///  Module (Gin) > AA
// ///
// ///  Server Logic
// ///  Handler
// ///

// ///
// ///  Frontend (Flutter)
// ///
// ///  StateManagement (Bloc)
// ///
// ///  App Logic
// ///  View
// ///