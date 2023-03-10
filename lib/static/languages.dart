import 'package:flutter/material.dart';

class AppLocale {
  // This class is not meant to be instantiated or extended; this constructor
  // prevents instantiation and extension.
  AppLocale._();

  static Locale en = const Locale.fromSubtags(languageCode: 'en');
  static Locale pt = const Locale.fromSubtags(languageCode: 'pt');
}
