import 'package:flutter/material.dart';

var appThemeData = ThemeData(
  brightness: Brightness.dark,
  fontFamily: 'Ubuntu',

  // Colores
  primaryColor: Color(0xFF1b83b3),
  accentColor: Color(0xFF24b373),
  canvasColor: Color(0xFFEDF0F7),
  splashColor: Color(0x22AAAAAA),
  cursorColor: Color(0xFFe43537),
  indicatorColor: Color(0xFFe43537),

  // Inputs
  inputDecorationTheme: InputDecorationTheme(
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.white),
    ),
    labelStyle: TextStyle(color: Colors.grey),
    focusColor: Colors.white,
  ),

  // App bar
  appBarTheme: AppBarTheme(
    textTheme: TextTheme(
      headline1: TextStyle(
        fontFamily: 'Ubuntu',
        fontWeight: FontWeight.bold,
        fontSize: 18,
      ),
    ),
  ),
);
