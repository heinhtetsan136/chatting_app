import 'package:flutter/material.dart';
import 'package:starlight_utils/starlight_utils.dart';

abstract class AppStandardTheme {
  Color get scaffoldBgColor;

  Color get scaffoldFgColor;

  Color get selectedColor;

  Color get unselectedColor;

  Color get containerBgColor;
  Color get primaryColor;
  Color get secondartyColor;
  Color get cardBgColor;

  Color get containerFgColor => Colors.white;

  Color get textColor => Colors.white;

  ThemeData get ref;
  static TextStyle getBodyTextStyle(BuildContext context) {
    return TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: context.theme.appBarTheme.titleTextStyle?.color,
    );
  }

  Color get outlinedButtonTextColor;
  TextStyle get titleTextStyle => TextStyle(
        fontSize: 18,
        color: textColor,
        fontWeight: FontWeight.w500,
      );
  ThemeData get theme => ref.copyWith(
        scaffoldBackgroundColor: scaffoldBgColor,
        appBarTheme: AppBarTheme(
          backgroundColor: scaffoldFgColor,
          foregroundColor: textColor,
        ),
        inputDecorationTheme: InputDecorationTheme(
          isDense: true,
          floatingLabelStyle: TextStyle(
            color: textColor,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: secondartyColor,
            ),
          ),
        ),
        iconButtonTheme: IconButtonThemeData(
          style: ButtonStyle(
            foregroundColor: WidgetStatePropertyAll(primaryColor),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
            foregroundColor: WidgetStatePropertyAll(primaryColor),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(primaryColor),
          foregroundColor: WidgetStatePropertyAll(textColor),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        )),
        cardColor: containerBgColor,
        cardTheme: CardTheme(
          shape: const RoundedRectangleBorder(),
          color: cardBgColor,
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: scaffoldFgColor,
          selectedItemColor: textColor,
          unselectedItemColor: unselectedColor,
        ),
        textTheme: ref.textTheme.copyWith(
          bodyLarge: TextStyle(color: textColor),
        ),
        listTileTheme: ListTileThemeData(
          textColor: textColor,
          tileColor: scaffoldFgColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        progressIndicatorTheme: ProgressIndicatorThemeData(
          color: selectedColor,
        ),
        drawerTheme: DrawerThemeData(
          backgroundColor: scaffoldBgColor,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: selectedColor,
          foregroundColor: containerFgColor,
        ),
      );
}
