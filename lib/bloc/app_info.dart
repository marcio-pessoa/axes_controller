import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:xc/controllers/string.dart';

abstract class Event {}

class Get extends Event {}

abstract class State {
  String app = '?';
  String system = '?';
}

class Initial extends State {}

class Loading extends State {}

class Loaded extends State {
  final String app;
  final String system;

  Loaded(
    this.app,
    this.system,
  );
}

class Error extends State {}

class MyBloc extends Bloc<Event, State> {
  MyBloc() : super(Initial()) {
    on<Get>((event, emit) async {
      try {
        emit(Loading());
        final PackageInfo result = await PackageInfo.fromPlatform();
        final appInfo = '${result.version}, Build/${result.buildNumber}';
        final systemInfo = kIsWeb
            ? 'Web'
            : '${Platform.operatingSystem.capitalize()}; Build/${Platform.operatingSystemVersion}';
        emit(Loaded(appInfo, systemInfo));
      } on Error {
        emit(Error());
      }
    });
  }
}
