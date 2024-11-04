import 'package:blca_project_app/theme/theme.dart';
import 'package:flutter/material.dart';

class AppLightTheme extends AppStandardTheme {
  @override
  // TODO: implement primaryColor
  Color get primaryColor => Colors.blue;
  @override
  // TODO: implement secondartyColor
  Color get secondartyColor => const Color.fromARGB(255, 37, 38, 41);
  @override
  Color get scaffoldBgColor => const Color.fromRGBO(239, 239, 243, 1);

  @override
  Color get scaffoldFgColor => const Color.fromRGBO(255, 255, 255, 1);

  @override
  Color get selectedColor => const Color.fromRGBO(254, 44, 85, 1);

  @override
  Color get unselectedColor => const Color.fromRGBO(149, 149, 149, 1);

  @override
  Color get cardBgColor => scaffoldFgColor;

  @override
  Color get containerBgColor => selectedColor;

  @override
  Color get containerFgColor => scaffoldFgColor;

  @override
  Color get textColor => const Color.fromRGBO(0, 0, 0, 1);

  @override
  ThemeData get ref => ThemeData.light();

  @override
  // TODO: implement outlinedButtonTextColor
  Color get outlinedButtonTextColor => const Color.fromRGBO(71, 84, 103, 1);
}

class AppDarkTheme extends AppStandardTheme {
  // TODO: implement primaryColor
  @override
  Color get primaryColor => const Color.fromRGBO(136, 136, 232, 1.0);
  @override
  // TODO: implement secondartyColor
  Color get secondartyColor => const Color.fromARGB(255, 146, 145, 146);
  @override
  Color get scaffoldBgColor => const Color.fromRGBO(0, 0, 0, 1);

  @override
  Color get scaffoldFgColor => const Color.fromRGBO(28, 28, 29, 1);

  @override
  Color get selectedColor => const Color.fromRGBO(254, 44, 85, 1);

  @override
  Color get unselectedColor => const Color.fromRGBO(130, 130, 130, 1);

  @override
  Color get cardBgColor => scaffoldFgColor;

  @override
  Color get containerBgColor => selectedColor;

  @override
  ThemeData get ref => ThemeData.light().copyWith(
        brightness: Brightness.dark,
      );

  @override
  // TODO: implement outlinedButtonTextColor
  Color get outlinedButtonTextColor => const Color.fromRGBO(71, 84, 103, 1);
}
