import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

themeName(context, theme) {
  switch (theme) {
    case ThemeMode.light:
      return AppLocalizations.of(context)!.themeLight;
    case ThemeMode.dark:
      return AppLocalizations.of(context)!.themeDark;
    case ThemeMode.system:
      return AppLocalizations.of(context)!.systemDefault;
  }
}
