import 'package:flutter/material.dart';
import 'package:xc/static/comm_interface.dart';

class CommInterfaceIcon extends StatelessWidget {
  final CommInterface interface;

  const CommInterfaceIcon({super.key, required this.interface});

  @override
  Widget build(BuildContext context) {
    switch (interface) {
      case CommInterface.bluetooth:
        return const Icon(Icons.bluetooth);
      case CommInterface.usb:
        return const Icon(Icons.usb_outlined);
      default:
        return const Icon(Icons.device_unknown_outlined);
    }
  }
}
