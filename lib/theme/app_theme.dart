import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: const Color(0xFFFFF5F7),

    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFFF4B6C2),
      foregroundColor: Color(0xFF4A3035),
    ),

    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color(0xFFE58FA0),
      foregroundColor: Colors.white,
    ),

    inputDecorationTheme: const InputDecorationTheme(
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Color(0xFFE58FA0),
          width: 2,
        ),
      ),
    ),

    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFFE58FA0),
      brightness: Brightness.light,
    ),
  );
}
