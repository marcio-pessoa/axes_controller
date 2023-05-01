import 'package:xc/static/baud_rate.dart';

class SerialState {
  final BaudRate baudRate;
  final String? address;

  SerialState({
    required this.baudRate,
    required this.address,
  });
}
