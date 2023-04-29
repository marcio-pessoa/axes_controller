import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:xc/cubit/bluetooth_cubit.dart';
import 'package:xc/cubit/comm_cubit.dart';
import 'package:xc/static/end_line.dart';

class Message {
  int whom;
  String text;

  Message(this.whom, this.text);
}

class Comm {
  BluetoothCubit device = BluetoothCubit();
  CommCubit configuration = CommCubit();
  var clientID = 0;
  BluetoothConnection? connection;
  List<Message> messages = List<Message>.empty(growable: true);
  String _messageBuffer = '';
  bool isConnecting = true;
  bool isDisconnecting = false;
  bool get isConnected => (connection?.isConnected ?? false);

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
      isConnecting = false;
      isDisconnecting = false;
    }).catchError((error) {
      log('Cannot connect, exception occured');
      log(error);
    });
  }

  dispose() {
    if (isConnected) {
      isDisconnecting = true;
      connection?.dispose();
      connection = null;
    }
  }

  send(String text) async {
    if (connection?.isConnected != true) {
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

      messages.add(Message(clientID, text));
    }
  }

  receive(Uint8List data) {
    // Allocate buffer for parsed data
    int backspacesCounter = 0;
    for (var byte in data) {
      if (byte == 8 || byte == 127) {
        backspacesCounter++;
      }
    }
    Uint8List buffer = Uint8List(data.length - backspacesCounter);
    int bufferIndex = buffer.length;

    // Apply backspace control character
    backspacesCounter = 0;
    for (int i = data.length - 1; i >= 0; i--) {
      if (data[i] == 8 || data[i] == 127) {
        backspacesCounter++;
      } else {
        if (backspacesCounter > 0) {
          backspacesCounter--;
        } else {
          buffer[--bufferIndex] = data[i];
        }
      }
    }

    // Create message if there is new line character
    String dataString = String.fromCharCodes(buffer);
    int index = buffer.indexOf(10);
    if (~index != 0) {
      messages.add(
        Message(
          1,
          backspacesCounter > 0
              ? _messageBuffer.substring(
                  0, _messageBuffer.length - backspacesCounter)
              : _messageBuffer + dataString.substring(0, index),
        ),
      );
      _messageBuffer = dataString.substring(index);
    } else {
      _messageBuffer = (backspacesCounter > 0
          ? _messageBuffer.substring(
              0, _messageBuffer.length - backspacesCounter)
          : _messageBuffer + dataString);
    }
  }
}
