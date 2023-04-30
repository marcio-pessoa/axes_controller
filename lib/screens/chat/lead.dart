import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:xc/screens/chat/bluetooth.dart';

class Chat extends StatelessWidget {
  const Chat({super.key});

  @override
  Widget build(BuildContext context) {
    Widget body = Container();

    if (Platform.isAndroid) {
      body = const ChatBluetooth();
      // } else if (Platform.isLinux) {
      //   return ChatSerial();
    }

    return Scaffold(
      appBar: AppBar(title: (Text(AppLocalizations.of(context)!.chat))),
      body: body,
    );
  }
}
