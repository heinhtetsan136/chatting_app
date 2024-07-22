import 'dart:async';

import 'package:blca_project_app/controller/contact_controller/contact_event.dart';
import 'package:blca_project_app/controller/contact_controller/contact_state.dart';
import 'package:blca_project_app/injection.dart';
import 'package:blca_project_app/repo/authService.dart';
import 'package:blca_project_app/repo/firestoreService.dart';
import 'package:blca_project_app/repo/user_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ContactBloc extends Bloc<ContactBaseEvent, ContactBaseState> {
  final AuthService _auth = Injection.get<AuthService>();
  final FireStoreService store = Injection.get<FireStoreService>();

  final List<ContactUser> posts = [];

  ContactBloc() : super(const ContactInitialState([])) {
    store.contactListener(_contactListener);

    on<RefreshContactEvent>(_refreshContactEventListener);
    on<GetContactEvent>(_getContactEventListener);

    on<NewContactEvent>(_newContactEventListener);

    add(GetContactEvent());
  }
  void _contactListener(ContactUser post) {
    if (post.uid == _auth.currentUser?.uid) {
      return;
    }
    final copied = state.posts.toList();
    final index = copied.indexOf(post);
    if (index == -1) {
      copied.add(post);
    } else {
      copied[index] = post;
    }
    add(NewContactEvent(copied));
  }

  FutureOr<void> _newContactEventListener(event, emit) async {
    emit(ContactSuccessState(event.post));
  }

  FutureOr<void> _getContactEventListener(_, emit) async {
    if (state is ContactLoadingState || state is ContactSoftLoadingState) {
      return;
    }
    final contact = state.posts.toList();
    if (contact.isEmpty) {
      emit(ContactLoadingState(contact));
    } else {
      emit(ContactSoftLoadingState(contact));
    }
    final result = await store.getUser();
    if (result.hasError) {
      emit(ContactFailedState(result.error!.message, contact));
    }

    emit(ContactSuccessState(result.data!));
  }

  FutureOr<void> _refreshContactEventListener(_, emit) async {
    if (state.posts.isEmpty) {
      emit(ContactLoadingState(state.posts));
    }
    final copied = state.posts.toList();
    final result = await store.getUser();
    if (result.hasError) {
      emit(ContactFailedState(result.error!.message, copied));
    }
    emit(ContactSuccessState(result.data!));
  }
}
