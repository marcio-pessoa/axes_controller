import 'dart:io';

import 'package:flutter/material.dart';
import 'package:xc/screens/chat/bluetooth.dart';
import 'package:xc/screens/chat/serial.dart';

class Chat extends StatefulWidget {
  const Chat({super.key});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  @override
  Widget build(BuildContext context) {
    Widget body = Container();

    if (Platform.isAndroid) {
      body = const BluetoothChat();
    } else if (Platform.isLinux) {
      return const SerialChat();
    }

    return body;
  }
}
