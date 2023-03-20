import 'dart:developer';

import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:xc/cubit/bluetooth_state.dart';

class BluetoothCubit extends HydratedCubit<MyBluetoothState> {
  BluetoothCubit()
      : super(
          MyBluetoothState(
            connection: const BluetoothDevice(address: ''),
            defaultPassword: '1234',
            autoPairing: false,
          ),
        );

  void set({connection, defaultPassword, autoPairing}) {
    connection = connection ?? state.connection;
    defaultPassword = defaultPassword ?? state.defaultPassword;
    autoPairing = autoPairing ?? state.autoPairing;

    final update = MyBluetoothState(
      connection: connection,
      defaultPassword: defaultPassword,
      autoPairing: autoPairing,
    );

    emit(update);
  }

  @override
  MyBluetoothState? fromJson(Map<String, dynamic> json) {
    log('Inside fromJson...');
    String address = json['connection'] ?? '';

    return MyBluetoothState(
      autoPairing: json['autoPairing'] ?? false,
      connection: BluetoothDevice(address: address),
      defaultPassword: json['defaultPassword'] ?? '1234',
    );
  }

  @override
  Map<String, dynamic>? toJson(MyBluetoothState state) {
    log('Inside toJson...');
    return {
      'autoPairing': state.autoPairing,
      'connection': state.connection.address,
      'defaultPassword': state.defaultPassword,
    };
  }
}
