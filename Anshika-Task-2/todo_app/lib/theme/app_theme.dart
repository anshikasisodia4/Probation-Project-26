import 'package:flutter/material.dart';

class AppTheme {
static ThemeData lightTheme = ThemeData(
primarySwatch: Colors.deepPurple,


scaffoldBackgroundColor: Colors.white,

appBarTheme: const AppBarTheme(
  backgroundColor: Colors.deepPurple,
  foregroundColor: Colors.white,
),

floatingActionButtonTheme: const FloatingActionButtonThemeData(
  backgroundColor: Colors.deepPurple,
  foregroundColor: Colors.white,
),

inputDecorationTheme: const InputDecorationTheme(
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.deepPurple,
      width: 2,
    ),
  ),
),


);
}
