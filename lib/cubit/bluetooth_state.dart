import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class MyBluetoothState {
  final BluetoothDevice connection;
  final String defaultPassword;

  MyBluetoothState({
    required this.connection,
    required this.defaultPassword,
  });
}
