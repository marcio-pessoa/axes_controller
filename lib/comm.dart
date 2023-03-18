import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:xc/cubit/comm_cubit.dart';
import 'package:xc/static/end_line.dart';

class Message {
  int whom;
  String text;

  Message(this.whom, this.text);
}

class Comm {
  static const clientID = 0;
  BluetoothConnection? connection;
  List<Message> messages = List<Message>.empty(growable: true);

  bool isConnecting = true;
  bool isDisconnecting = false;
  bool get isConnected => (connection?.isConnected ?? false);
  CommCubit configuration = CommCubit();

  start(CommCubit userConfig, BluetoothDevice server) {
    if (server.address == '') {
      log('Not connected.');
      return;
    }

    configuration = userConfig;

    BluetoothConnection.toAddress(server.address).then((connection) {
      log('Connected to the device');
      connection = connection;

      isConnecting = false;
      isDisconnecting = false;

      // connection!.input!.listen(_onDataReceived).onDone(() {
      //   // Example: Detect which side closed the connection
      //   // There should be `isDisconnecting` flag to show are we are (locally)
      //   // in middle of disconnecting process, should be set before calling
      //   // `dispose`, `finish` or `close`, which all causes to disconnect.
      //   // If we except the disconnection, `onDone` should be fired as result.
      //   // If we didn't except this (no flag set), it means closing by remote.
      //   if (isDisconnecting) {
      //     print("Disconectado localmente!");
      //   } else {
      //     print("Desconectado remotamente!");
      //   }
      //   if (this.mounted) {
      //     setState(() {});
      //   }
      // });
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
      connection!.output.add(Uint8List.fromList(utf8.encode(
        "$text${configuration.state.endLine.chars}",
      )));
      await connection!.output.allSent;

      messages.add(Message(clientID, text));
    }
  }

  receive() {}
}
