import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xc/cubit/settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
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
}
