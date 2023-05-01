import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';

class ChatSerial {
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

  Uint8List _stringToUinut8List(String data) {
    List<int> codeUnits = data.codeUnits;
    Uint8List uint8list = Uint8List.fromList(codeUnits);
    return uint8list;
  }
}
