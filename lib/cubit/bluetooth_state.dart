import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class MyBluetoothState {
  final BluetoothDevice connection;
  final String defaultPassword;
  final bool autoPairing;

  MyBluetoothState({
    required this.connection,
    required this.defaultPassword,
    required this.autoPairing,
  });
}
