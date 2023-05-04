import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:xc/cubit/bluetooth_cubit.dart';
import 'package:xc/cubit/comm_cubit.dart';
import 'package:xc/static/comm_status.dart';
import 'package:xc/static/end_line.dart';

class CommBluetooth {
  BluetoothCubit device = BluetoothCubit();
  CommCubit configuration = CommCubit();
  int clientID = 0;
  BluetoothConnection? connection;
  String messageBuffer = '';
  bool isConnecting = true;
  bool isDisconnecting = false;
  bool get isConnected => (connection?.isConnected ?? false);
  CommStatus status = CommStatus.connecting;

  Future<void> init(
      BluetoothCubit userDevice, CommCubit userPreferences) async {
    configuration = userPreferences;
    device = userDevice;
    final address = device.state.connection.address;

    if (address.isEmpty) {
      log('Not connected. :-(');
      return;
    }

    final btConnection = BluetoothConnection.toAddress(address);

    await btConnection.then((connect) {
      log('Connected to the device');
      connection = connect;
      status = CommStatus.connected;
      isConnecting = false;
      isDisconnecting = false;
    }).catchError((error) {
      log('Cannot connect, exception occured');
      log(error);
    });
  }

  dispose() {
    if (isConnected) {
      status = CommStatus.disconnecting;
      isDisconnecting = true;
      connection?.dispose();
      connection = null;
      status = CommStatus.disconnected;
    }
  }

  Future<void> send(String text) async {
    if (connection?.isConnected != true) {
      status = CommStatus.disconnected;
      log('Not connected.');
      return;
    }

    if (text.isNotEmpty) {
      connection!.output.add(
        Uint8List.fromList(
          utf8.encode("$text${configuration.state.endLine.chars}"),
        ),
      );
      await connection!.output.allSent;
    }
  }

  receive(Uint8List data) {}
}
