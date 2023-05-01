import 'dart:io';

import 'package:flutter/material.dart';
import 'package:xc/screens/chat/bluetooth.dart';

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
      body = const ChatBluetooth();
      // } else if (Platform.isLinux) {
      //   return ChatSerial();
    }

    return body;
  }
}
