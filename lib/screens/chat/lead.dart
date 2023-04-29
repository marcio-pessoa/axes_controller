import 'dart:io';

import 'package:flutter/material.dart';
import 'package:xc/screens/chat/bluetooth.dart';

class Chat extends StatelessWidget {
  const Chat({super.key});

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      return const ChatBluetooth();
      // } else if (Platform.isLinux) {
      //   return ChatSerial();
    } else {
      return Container();
    }
  }
}
