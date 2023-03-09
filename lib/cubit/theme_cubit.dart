import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xc/cubit/theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(ThemeState(theme: ThemeData.light()));

  void toggleTheme() {
    if (state.theme == ThemeData.light()) {
      final update = ThemeState(theme: ThemeData.dark());
      emit(update);
    } else {
      final update = ThemeState(theme: ThemeData.light());
      emit(update);
    }
  }
}
