import 'dart:async';

import 'package:blca_project_app/controller/home_controller/home_controller_event.dart';
import 'package:blca_project_app/controller/home_controller/home_controller_state.dart';
import 'package:blca_project_app/injection.dart';
import 'package:blca_project_app/repo/authService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePageBloc extends Bloc<HomePageEvent, HomeBlocBaseState> {
  final PageController controller;
  static const Duration _duration = Duration(milliseconds: 300);
  static const Curve _curve = Curves.linear;
  final AuthService _authService = Injection.get<AuthService>();
  StreamSubscription? _authstate;
  HomePageBloc()
      : controller = PageController(),
        super(const HomeBlocNavigationState(0)) {
    _authService.currentUser?.reload();
    _authstate = _authService.authState().listen((user) {
      print("homebloc user $user");
      if (user == null) {
        add(const SignoutEvent());
      }
    });
    on<gotoHomePage>(
      (event, emit) {
        emit(const HomeBlocNavigationState(0));
        controller.animateToPage(0, duration: _duration, curve: _curve);
      },
    );
    on<gotoContactScreen>(
      (event, emit) {
        emit(const HomeBlocNavigationState(1));
        controller.animateToPage(1, duration: _duration, curve: _curve);
      },
    );
    on<gotoPost>(
      (event, emit) {
        emit(const HomeBlocNavigationState(2));
        controller.animateToPage(2, duration: _duration, curve: _curve);
      },
    );
    on<SignoutEvent>((_, emit) async {
      print("SignoutEvent");
      await _authService.signOut();
      emit(const HomeLogout());
    });
  }
  HomePageEvent activate(int value) {
    switch (value) {
      case 0:
        return const gotoHomePage();

      case 1:
        return const gotoContactScreen();
      default:
        return const gotoPost();
    }
  }

  @override
  Future<void> close() {
    print("home bloc is close");
    controller.dispose();
    _authService.dispose();
    _authstate?.cancel();
    _authstate == null;
    // TODO: implement close
    return super.close();
  }
}
