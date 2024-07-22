import 'dart:io';

import 'package:blca_project_app/controller/chatting/chatting_event.dart';
import 'package:blca_project_app/controller/chatting/chatting_state.dart';
import 'package:blca_project_app/injection.dart';
import 'package:blca_project_app/logger.dart';
import 'package:blca_project_app/repo/authService.dart';
import 'package:blca_project_app/repo/chatRoom_model.dart';
import 'package:blca_project_app/repo/chattingService.dart';
import 'package:blca_project_app/repo/firestoreService.dart';
import 'package:blca_project_app/repo/message.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class ChattingBloc extends Bloc<ChattingEvent, ChattingState> {
  ValueNotifier<bool> text = ValueNotifier(false);
  final AuthService _authService = Injection.get<AuthService>();
  final ChatRoom chatRoom;
  final FireStoreService _storeService = Injection.get<FireStoreService>();
  final FirebaseStorage _firebaseStorage = Injection.get<FirebaseStorage>();
  final ImagePicker _imagePicker = ImagePicker();
  final FocusNode focusNode = FocusNode();
  final TextEditingController textEditingController = TextEditingController();
  final Chattingservice chatRoomService = Injection.get<Chattingservice>();

  ChattingBloc(super.initialState, this.chatRoom) {
    chatRoomService.contactListener(contactListener, chatRoom.id);
    on<ChattingGetAllMessageEvent>((event, emit) async {
      final messages = state.message.toList();
      if (messages.isEmpty) {
        emit(ChattingLoadingState(messages));
      } else {
        emit(ChattingSoftLoadingState(messages));
      }

      final result = await chatRoomService.getMessages(chatRoom.id);
      logger.i("message is  ${result.hasError ?? ""}");
      if (result.hasError) {
        emit(ChattingErrorState(messages, result.error!.message.toString()));
        return;
      }
      emit(ChattingLoadedState(result.data));
    });
    int tryCount = 0;
    int limit = 20;
    on<ChattingRefreshMessageEvent>((_, emit) async {
      final copied = state.message.toList();
      if (copied.isEmpty) {
        emit(ChattingLoadingState(copied));
      }
      logger.i("trycount $limit");

      limit = limit + 20;
      final result = await chatRoomService.getMessages(
        chatRoom.id,
        limit,
      );

      if (result.hasError) {
        emit(ChattingErrorState(copied, result.error!.message.toString()));
        return;
      }
      if (copied.length == result.data.length) {
        limit = 20;

        logger.i("trycountget $limit");
        emit(ChattingSoftLoadingState(copied));
      }
      emit(ChattingLoadedState(result.data));
    });
    on<ChattingNewMessageEvent>((event, emit) {
      emit(ChattingLoadedState(event.post));
    });
    add(const ChattingGetAllMessageEvent());
  }
  void pickImage() async {
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
    await chatRoomService.sendMessage(payload);
  }

  void sendMessage() async {
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
    await chatRoomService.sendMessage(payload);

    focusNode.unfocus();
  }

  void toggle() {
    text.value = !text.value;
  }

  void contactListener(Message message) {
    final copied = state.message.toList();
    if (copied.isEmpty) {
      add(const ChattingGetAllMessageEvent());
      return;
    }
    print("new message $copied");
    final index = copied.indexOf(message);
    if (index == -1) {
      copied.insert(0, (message));
    } else {
      copied[index] = message;
    }
    print("new message addd $copied");
    add(ChattingNewMessageEvent(copied));
  }

  @override
  Future<void> close() {
    textEditingController.dispose();
    focusNode.dispose();
    // TODO: implement close
    return super.close();
  }
}
