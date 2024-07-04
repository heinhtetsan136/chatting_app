import 'package:blca_project_app/controller/home_controller_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePageBloc extends Bloc<HomePageEvent, int> {
  final PageController controller;
  static const Duration _duration = Duration(milliseconds: 300);
  static const Curve _curve = Curves.linear;
  HomePageBloc()
      : controller = PageController(),
        super(0) {
    on<gotoHomePage>(
      (event, emit) {
        emit(0);
        controller.animateToPage(0, duration: _duration, curve: _curve);
      },
    );
    on<gotoContactScreen>(
      (event, emit) {
        emit(1);
        controller.animateToPage(1, duration: _duration, curve: _curve);
      },
    );
    on<gotoSettings>(
      (event, emit) {
        emit(2);
        controller.animateToPage(2, duration: _duration, curve: _curve);
      },
    );
  }
  HomePageEvent activate(int value) {
    switch (value) {
      case 0:
        return const gotoHomePage();

      case 1:
        return const gotoContactScreen();
      default:
        return const gotoSettings();
    }
  }

  @override
  Future<void> close() {
    controller.dispose();
    // TODO: implement close
    return super.close();
  }
}
