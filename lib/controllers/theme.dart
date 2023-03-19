import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

themeLocaleName(context, theme) {
  switch (theme) {
    case ThemeMode.light:
      return AppLocalizations.of(context)!.themeLight;
    case ThemeMode.dark:
      return AppLocalizations.of(context)!.themeDark;
    case ThemeMode.system:
      return AppLocalizations.of(context)!.systemDefault;
  }
}

themeMode(name) {
  switch (name) {
    case 'light':
      return ThemeMode.light;
    case 'dark':
      return ThemeMode.dark;
    case 'system':
      return ThemeMode.system;
  }
}
