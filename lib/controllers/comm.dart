import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:xc/cubit/bluetooth_cubit.dart';
import 'package:xc/cubit/comm_cubit.dart';
import 'package:xc/cubit/serial_cubit.dart';
import 'package:xc/static/comm_interface.dart';
import 'package:xc/static/comm_status.dart';
import 'package:xc/static/end_line.dart';

class Comm {
  late final dynamic device;
  CommCubit configuration = CommCubit();
  int clientID = 0;
  BluetoothConnection? connection;
  String messageBuffer = '';
  bool isConnecting = true;
  bool isDisconnecting = false;
  bool get isConnected => (connection?.isConnected ?? false);
  CommStatus status = CommStatus.connecting;
  String? name;
  late SerialPort port;
  late SerialPortReader reader;
  late CommInterface _interface;

  Future<void> initBluetooth(
      BluetoothCubit userDevice, CommCubit userPreferences) async {
    configuration = userPreferences;
    device = userDevice;

    _interface = CommInterface.bluetooth;

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
      name = device.state.connection.name;
      isConnecting = false;
      isDisconnecting = false;
    }).catchError((error) {
      log('Cannot connect, exception occured');
      log(error);
    });
  }

  Future<void> initSerial(
      SerialCubit userDevice, CommCubit userPreferences) async {
    device = userDevice;
    configuration = userPreferences;

    _interface = CommInterface.usb;

    final address = device.state.address.toString();

    if (address.isEmpty) {
      log('Not connected. :-(');
      return;
    }

    port = SerialPort(address);
    port.openReadWrite();

    try {
      // debugPrint("Writen bytes: ${port.write(stringToUinut8List("Hello"))}");
      reader = SerialPortReader(port);

      if (port.isOpen) {
        status = CommStatus.connected;
        name = port.name;
      }
    } on SerialPortError catch (err, _) {
      debugPrint(SerialPort.lastError.toString());
    }
  }

  dispose() {
    if (status == CommStatus.connected) {
      status = CommStatus.disconnecting;

      switch (_interface) {
        case CommInterface.bluetooth:
          disposeBluetooth();
          break;
        case CommInterface.usb:
          disposeSerial();
          break;
        default:
          status = CommStatus.disconnected;
          break;
      }

      status = CommStatus.disconnected;
    }
  }

  disposeBluetooth() {
    connection?.dispose();
    connection = null;
  }

  disposeSerial() {
    port.close();
  }

  Future<void> send(String text) async {
    switch (_interface) {
      case CommInterface.bluetooth:
        await sendBluetooth(text);
        break;
      case CommInterface.usb:
        await sendSerial(text);
        break;
      default:
        status = CommStatus.disconnected;
        break;
    }
  }

  Future<void> sendBluetooth(String text) async {
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

  Future<void> sendSerial(String text) async {
    if (!port.isOpen) {
      status = CommStatus.disconnected;
      // debugPrint('Not connected.');
      return;
    }

    if (text.isNotEmpty) {
      // debugPrint("Sending message: $text");
      try {
        port.write(
          stringToUinut8List("$text${configuration.state.endLine.chars}"),
        );
      } on SerialPortError catch (error) {
        debugPrint(error.toString());
      }
    }
  }

  receive(Uint8List data) {}

  Uint8List stringToUinut8List(String data) {
    List<int> codeUnits = data.codeUnits;
    Uint8List uint8list = Uint8List.fromList(codeUnits);
    return uint8list;
  }
}
