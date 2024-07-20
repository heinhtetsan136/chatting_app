import 'package:blca_project_app/controller/chat_room/chat_room_create_controller/chat_room_create_event.dart';
import 'package:blca_project_app/controller/chat_room/chat_room_create_controller/chat_room_create_state.dart';
import 'package:blca_project_app/injection.dart';
import 'package:blca_project_app/logger.dart';
import 'package:blca_project_app/repo/authService.dart';
import 'package:blca_project_app/repo/chatRoom_model.dart';
import 'package:blca_project_app/repo/chatroom_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatRoomCreateBloc
    extends Bloc<ChatRoomCreateEvent, ChatRoomCreateState> {
  final ChatRoomService chatRoomService = Injection.get<ChatRoomService>();
  final AuthService _authService = Injection.get<AuthService>();
  ChatRoomCreateBloc(super.initialState) {
    on<ChatRoomOnCreateEvent>((event, emit) async {
      if (state is ChatRoomCreateLoadingState) {
        return;
      }
      emit(const ChatRoomCreateLoadingState());
      final chatRoomParams = ChatRoomParams.toCreate(
          Updated_At: Timestamp.now(),
          toUserName: event.other.email,
          text: " ",
          member: [_authService.currentUser!.uid, event.other.uid],
          formUserId: _authService.currentUser!.uid,
          toUserId: event.other.uid);
      final result = await chatRoomService.checkChatRoomCreateifNotExist(
          event.other, chatRoomParams);
      logger.i("result bloc create ${result.data}");
      if (result.hasError) {
        emit(ChatRoomCreateErrorState(result.error!.message.toString()));
        return;
      }
      emit(ChatRoomCreateSuccessState(ChatRoom.fromJson(result.data)));
      logger.i("in old room");
    });
  }
}
