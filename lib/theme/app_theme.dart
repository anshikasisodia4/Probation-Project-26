import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: const Color(0xFFEAF4FF),

    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF64B5F6),
      foregroundColor:Colors.white,
    ),

    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color(0xFF2196F3),
      foregroundColor: Colors.white,
    ),

    inputDecorationTheme: const InputDecorationTheme(
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Color(0xFF2196F3),
          width: 3,
        ),
      ),
    ),

    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF2196F3),
      brightness: Brightness.light,
    ),
  );
}
