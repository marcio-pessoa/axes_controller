import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xc/cubit/theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(ThemeState(theme: ThemeMode.system));

  void setTheme(ThemeMode theme) {
    final state = ThemeState(theme: theme);
    emit(state);
  }
}
