import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:xc/controllers/theme.dart';
import 'package:xc/cubit/settings_state.dart';

class SettingsCubit extends HydratedCubit<SettingsState> {
  SettingsCubit()
      : super(SettingsState(
          theme: ThemeMode.system,
          locale: const Locale('en'),
        ));

  void set({
    theme,
    locale,
  }) {
    theme = theme ?? state.theme;
    locale = locale ?? state.locale;

    final update = SettingsState(
      theme: theme,
      locale: locale,
    );

    emit(update);
  }

  @override
  SettingsState? fromJson(Map<String, dynamic> json) {
    log('Inside fromJson...');
    return SettingsState(
      theme: themeMode(json['theme']),
      locale: Locale(json['locale']),
    );
  }

  @override
  Map<String, dynamic>? toJson(SettingsState state) {
    log('Inside toJson...');
    return {
      'theme': state.theme.name,
      'locale': state.locale.languageCode,
    };
  }
}
