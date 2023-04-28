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
  var clientID = 0;
  BluetoothConnection? connection;
  CommCubit configuration = CommCubit();
  List<Message> messages = List<Message>.empty(growable: true);
  String _messageBuffer = '';
  bool isConnecting = true;
  bool isDisconnecting = false;
  bool get isConnected => (connection?.isConnected ?? false);

  init(BluetoothCubit device, CommCubit preferences) {
    if (device.state.connection.address == '') {
      log('Not connected. :-(');
      return;
    }

    configuration = preferences;

    BluetoothConnection.toAddress(device.state.connection.address)
        .then((connectionInternal) {
      log('Connected to the device');
      connection = connectionInternal;

      isConnecting = false;
      isDisconnecting = false;

      connection!.input!.listen(receive).onDone(() {
        //   // Example: Detect which side closed the connection
        //   // There should be `isDisconnecting` flag to show are we are (locally)
        //   // in middle of disconnecting process, should be set before calling
        //   // `dispose`, `finish` or `close`, which all causes to disconnect.
        //   // If we except the disconnection, `onDone` should be fired as result.
        //   // If we didn't except this (no flag set), it means closing by remote.
        if (isDisconnecting) {
          log("Disconectado localmente!");
        } else {
          log("Desconectado remotamente!");
        }
      });
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
