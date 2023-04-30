import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:xc/cubit/chat_cubit.dart';
import 'package:xc/screens/chat/bluetooth.dart';
import 'package:xc/static/colors.dart';

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

    return Scaffold(
      appBar: AppBar(
        title: (Text(AppLocalizations.of(context)!.chat)),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.speaker_notes_off_outlined),
            onPressed: _clearChatDialog,
          )
        ],
      ),
      body: body,
    );
  }

  Future<void> _clearChatDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.chatClear),
          content: Text(AppLocalizations.of(context)!.chatClearConfirm),
          actions: <Widget>[
            TextButton(
              child: Text(
                AppLocalizations.of(context)!.yes,
                style: const TextStyle(color: MyColors.alert),
              ),
              onPressed: () {
                final chat = context.read<ChatCubit>();
                chat.clear();
                setState(() {});
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(AppLocalizations.of(context)!.no),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
