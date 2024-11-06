import 'package:blca_project_app/injection.dart';
import 'package:blca_project_app/model/error.dart';
import 'package:blca_project_app/model/result.dart';
import 'package:blca_project_app/repo/authService.dart';
import 'package:blca_project_app/repo/ui_video_call_Service.dart/video_call_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum callState { idle, calling, callEnded }

class VideoCallService {
  final AuthService _authService = Injection.get<AuthService>();
  final FirebaseFirestore _db = Injection.get<FirebaseFirestore>();
  Future<Result> _try(Future<Result> Function() callback) async {
    try {
      final result = await callback();
      return result;
    } on FirebaseException catch (e) {
      return Result(error: GeneralError(e.message.toString()));
    } catch (e) {
      print("error is ${e.toString()}");
      return const Result(error: GeneralError("Something went wrong"));
    }
  }

  VideoCallService() {
    String userId = _authService.currentUser!.uid;

    Future<Result> getVideoCall() async {
      return _try(() async {
        final result = await _db
            .collection("VideoCall")
            .where("'receiverId'", isEqualTo: userId)
            .get();
        List<VideoCallModel> call = [];
        for (var item in result.docs) {
          final model = VideoCallModel.fromJson(item.data());
          call.add(model);
        }
        return Result(data: call);
      });
    }

    Future<Result> updateCalltate(String id, String c, callState state) async {
      return _try(() async {
        final result = await _db
            .collection("VideoCall")
            .doc(id)
            .update({"state": state.name});
        return const Result(data: ());
      });
    }

    Future<Result> deleteVideoCall(String id) async {
      return _try(() async {
        final result = await _db.collection("VideoCall").doc(id).delete();
        return const Result(data: ());
      });
    }

    Future<Result> createVideoCall(VideoCallModelParams model) async {
      return _try(() async {
        final payload = model.toCreate();
        final doc = _db.collection("VideoCall").doc();
        payload.addEntries({MapEntry("id", doc.id)});
        await doc.set(payload, SetOptions(merge: true));
        return const Result(data: null);
      });
    }
  }
}
