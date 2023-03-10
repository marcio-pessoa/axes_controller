import 'package:flutter/material.dart';

class AppTheme {
  // This class is not meant to be instantiated or extended; this constructor
  // prevents instantiation and extension.
  AppTheme._();

  static ThemeData light = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.green,
    useMaterial3: true,
  );
  static ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.green,
    useMaterial3: true,
  );
}
