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

  Future<void> init(SerialCubit userDevice, CommCubit userPreferences) async {
    device = userDevice;
    configuration = userPreferences;
    final address = device.state.address;

    if (address?.isEmpty ?? true) {
      log('Not connected. :-(');
      return;
    }
  }

  dispose() {
    if (status == CommStatus.connected) {
      status = CommStatus.disconnecting;

      status = CommStatus.disconnected;
    }
  }

  serial() {
    String address = "/dev/ttyS4";
    SerialPort port = SerialPort(address);
    port.openReadWrite();

    try {
      debugPrint("Writen bytes: ${port.write(_stringToUinut8List("Hello"))}");
      SerialPortReader reader = SerialPortReader(port);
      Stream<String> upcommingData = reader.stream.map((event) {
        return String.fromCharCodes(event);
      });

      upcommingData.listen((event) {
        debugPrint('Read data: $event');
      });
    } on SerialPortError catch (err, _) {
      debugPrint(SerialPort.lastError.toString());
      port.close();
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
