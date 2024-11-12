import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class VideoCallModel extends Equatable {
  @override
  List<Object> get props => [id, callerId, receiverId, callState, timeStamp];
  final String id;
  final String callerId;
  final String receiverId;
  final String callState;
  final Timestamp timeStamp;
  const VideoCallModel(
      {required this.callerId,
      required this.callState,
      required this.id,
      required this.receiverId,
      required this.timeStamp});
  factory VideoCallModel.fromJson(Map<String, dynamic> data) {
    return VideoCallModel(
      callState: data['callState'],
      id: data['id'],
      callerId: data['callerId'],
      receiverId: data['receiverId'],
      timeStamp: data['timeStamp'],
    );
  }
}

class VideoCallModelParams {
  final String callerId;
  final String callState;
  final String receiverId;
  final Timestamp timeStamp;
  VideoCallModelParams(
      {required this.callerId,
      required this.receiverId,
      required this.callState,
      required this.timeStamp});
  factory VideoCallModelParams.toCreate({
    required String callerId,
    required String receiverId,
    required String callState,
    required Timestamp timeStamp,
  }) {
    return VideoCallModelParams(
      callerId: callerId,
      callState: callState,
      receiverId: receiverId,
      timeStamp: timeStamp,
    );
  }
  Map<String, dynamic> toCreate() {
    return {
      "callState": callState,
      'callerId': callerId,
      'receiverId': receiverId,
      'timeStamp': timeStamp,
    };
  }
}
