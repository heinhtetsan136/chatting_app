import 'dart:io';

import 'package:blca_project_app/controller/chatting/send_data/send_data_event.dart';
import 'package:blca_project_app/controller/chatting/send_data/send_data_state.dart';
import 'package:blca_project_app/injection.dart';
import 'package:blca_project_app/logger.dart';
import 'package:blca_project_app/repo/authService.dart';
import 'package:blca_project_app/repo/chatRoom_model.dart';
import 'package:blca_project_app/repo/chattingService.dart';
import 'package:blca_project_app/repo/firestoreService.dart';
import 'package:blca_project_app/repo/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class SendDataBloc extends Bloc<SendDataBaseEvent, SendDataBaseState> {
  final TextEditingController textEditingController = TextEditingController();
  final ChatRoom chatRoom;
  final ImagePicker _imagePicker = ImagePicker();
  final FocusNode focusNode = FocusNode();
  final FirebaseStorage _firebaseStorage = Injection.get<FirebaseStorage>();
  final Chattingservice chattingService = Injection.get<Chattingservice>();
  final AuthService _authService = Injection.get<AuthService>();
  final FireStoreService _storeService = Injection.get<FireStoreService>();
  SendDataBloc(this.chatRoom)
      : super(
          const SendDataInitialState(),
        ) {
    on<SendPhotoEvent>((_, emit) async {
      final image = await _imagePicker.pickImage(source: ImageSource.gallery);
      if (image == null) return;

      //  final ref = _storage.ref().child("user_profile/${user.uid}");
      // final profilePath = "users/${user.uid}_${DateTime.now().toIso8601String()}";
      // await _storage.ref(profilePath).putFile(File(profilePath));
      final point = _firebaseStorage
          .ref()
          .child("messages/${chatRoom.id}/${DateTime.now().toIso8601String()}");
      final roompath =
          "messages/${chatRoom.id}/${DateTime.now().toIso8601String()}";
      await _firebaseStorage.ref(roompath).putFile(File(image.path));
      final message = await _firebaseStorage.ref(roompath).getDownloadURL();
      final payload = MessageParams.toCreate(
        chatRoomId: chatRoom.id,
        data: message,
        fromUser: _authService.currentUser!.uid,
        isText: false,
      );
      final Map<String, dynamic> userSend = payload.toCreate();
      userSend.addEntries({MapEntry("id", chatRoom.id)});
      userSend.addEntries({MapEntry("sendingTime", Timestamp.now())});
      emit(SendDataLoadingState(Message.fromJson(userSend)));
      final result = await chattingService.sendMessage(payload);
      logger.e("result ${result.hasError}");
      if (result.hasError) {
        emit(SendDataErrorState(
            result.error!.message.toString(), Message.fromJson(userSend)));
      }
      emit(SendDataLoadedState(Message.fromJson(userSend)));
    });

    on<SendMessageEvent>((event, emit) async {
      final message = textEditingController.text;
      if (message.isEmpty) {
        return;
      }

      textEditingController.clear();
      final payload = MessageParams.toCreate(
        chatRoomId: chatRoom.id,
        data: message,
        fromUser: _authService.currentUser!.uid,
      );
      final Map<String, dynamic> userSend = payload.toCreate();
      userSend.addEntries({MapEntry("id", chatRoom.id)});
      userSend.addEntries({MapEntry("sendingTime", Timestamp.now())});

      emit(SendDataLoadingState(Message.fromJson(userSend)));
      final result = await chattingService.sendMessage(payload);
      logger.e("result ${result.hasError}");
      if (result.hasError) {
        emit(SendDataErrorState(
            result.error!.message.toString(), Message.fromJson(userSend)));
      }

      emit(SendDataLoadedState(Message.fromJson(userSend)));
    });
  }
  @override
  Future<void> close() {
    textEditingController.dispose();
    focusNode.dispose();
    // TODO: implement close
    return super.close();
  }
}
