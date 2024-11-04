import 'package:blca_project_app/injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  final SharedPreferences _shardPreferences = Injection<SharedPreferences>();

  ThemeCubit(super.initialState);

  void toggleTheme() {
    final isDarkTheme = state == ThemeMode.dark;
    _shardPreferences.setBool("current_theme", !isDarkTheme);
    emit(isDarkTheme ? ThemeMode.light : ThemeMode.dark);
  }
}
