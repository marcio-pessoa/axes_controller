import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:xc/cubit/comm_cubit.dart';
import 'package:xc/cubit/serial_cubit.dart';
import 'package:xc/static/comm_status.dart';

class CommSerial {
  SerialCubit device = SerialCubit();
  CommCubit configuration = CommCubit();
  CommStatus status = CommStatus.connecting;
  late SerialPort port;
  late SerialPortReader reader;

  Future<void> init(SerialCubit userDevice, CommCubit userPreferences) async {
    device = userDevice;
    configuration = userPreferences;
    final address = device.state.address.toString();

    if (address.isEmpty) {
      log('Not connected. :-(');
      return;
    }

    port = SerialPort(address);
    port.openReadWrite();

    try {
      debugPrint("Writen bytes: ${port.write(_stringToUinut8List("Hello"))}");
      reader = SerialPortReader(port);

      if (port.isOpen) {
        status = CommStatus.connected;
      }
    } on SerialPortError catch (err, _) {
      debugPrint(SerialPort.lastError.toString());
    }
  }

  dispose() {
    if (status == CommStatus.connected) {
      status = CommStatus.disconnecting;
      port.close();
      status = CommStatus.disconnected;
    }
  }

  Future<void> send(String text) async {}

  receive(Uint8List data) {}

  Uint8List _stringToUinut8List(String data) {
    List<int> codeUnits = data.codeUnits;
    Uint8List uint8list = Uint8List.fromList(codeUnits);
    return uint8list;
  }
}
