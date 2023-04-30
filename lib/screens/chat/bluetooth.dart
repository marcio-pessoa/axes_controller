import 'dart:async';
import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:xc/controllers/comm_bluetooth.dart';
import 'package:xc/cubit/bluetooth_cubit.dart';
import 'package:xc/cubit/chat_cubit.dart';
import 'package:xc/cubit/comm_cubit.dart';

class ChatBluetooth extends StatefulWidget {
  const ChatBluetooth({super.key});

  @override
  State<ChatBluetooth> createState() => _Chat();
}

class _Chat extends State<ChatBluetooth> {
  final TextEditingController textEditingController = TextEditingController();
  final ScrollController _listScrollController = ScrollController();
  Comm comm = Comm();

  @override
  void initState() {
    super.initState();
    _initComm();
  }

  @override
  void dispose() {
    comm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chat = context.read<ChatCubit>();

    final List<Row> list = chat.state.messages.map((message) {
      return Row(
        mainAxisAlignment: message.whom == comm.clientID
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(12.0),
            margin: const EdgeInsets.only(bottom: 8.0, left: 8.0, right: 8.0),
            width: 222.0,
            decoration: BoxDecoration(
                color: message.whom == comm.clientID
                    ? Colors.blueAccent
                    : Colors.grey,
                borderRadius: BorderRadius.circular(7.0)),
            child: Text(
                (text) {
                  return text == '/shrug' ? '¯\\_(ツ)_/¯' : text;
                }(message.text.trim()),
                style: const TextStyle(color: Colors.white)),
          ),
        ],
      );
    }).toList();

    final serverName = comm.device.state.connection.name ??
        AppLocalizations.of(context)!.unknown;

    String hintText = comm.isConnecting
        ? AppLocalizations.of(context)!.waitConnection
        : comm.isConnected
            ? "${AppLocalizations.of(context)!.typeMessage} $serverName"
            : AppLocalizations.of(context)!.chatDetached;

    return Column(
      children: <Widget>[
        Flexible(
          child: ListView(
              padding: const EdgeInsets.all(12.0),
              controller: _listScrollController,
              children: list),
        ),
        Row(
          children: <Widget>[
            Flexible(
              child: Container(
                margin: const EdgeInsets.only(left: 16.0),
                child: TextField(
                  style: const TextStyle(fontSize: 15.0),
                  controller: textEditingController,
                  decoration: InputDecoration.collapsed(
                    hintText: hintText,
                    hintStyle: const TextStyle(color: Colors.grey),
                  ),
                  enabled: comm.isConnected,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(8.0),
              child: IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: comm.isConnected ? () => _send() : null),
            ),
          ],
        )
      ],
    );
  }

  _initComm() async {
    final device = context.read<BluetoothCubit>();
    final preferences = context.read<CommCubit>();

    await comm.init(device, preferences);

    setState(() {});

    if (comm.isConnected) {
      comm.connection!.input!.listen(_receive).onDone(() {
        // Example: Detect which side closed the connection
        // There should be `isDisconnecting` flag to show are we are (locally)
        // in middle of disconnecting process, should be set before calling
        // `dispose`, `finish` or `close`, which all causes to disconnect.
        // If we except the disconnection, `onDone` should be fired as result.
        // If we didn't except this (no flag set), it means closing by remote.
        if (comm.isDisconnecting) {
          log("Desconectado localmente!");
        } else {
          log("Desconectado remotamente!");
        }
        if (mounted) {
          setState(() {});
        }
      });
    }
  }

  void _send() async {
    final text = textEditingController.text.trim();

    if (text.isEmpty) {
      return;
    }

    final chat = context.read<ChatCubit>();

    try {
      await comm.send(text);
      chat.add(Message(comm.clientID, text));

      setState(() {
        textEditingController.clear();
      });

      const duration = 333;
      Future.delayed(const Duration(milliseconds: duration)).then((_) {
        _listScrollController.animateTo(
            _listScrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: duration),
            curve: Curves.easeOut);
      });
    } catch (error) {
      log(error.toString());
      setState(() {});
    }
  }

  void _receive(Uint8List event) {
    // Allocate buffer for parsed data
    int backspacesCounter = 0;
    for (var byte in event) {
      if (byte == 8 || byte == 127) {
        backspacesCounter++;
      }
    }
    Uint8List buffer = Uint8List(event.length - backspacesCounter);
    int bufferIndex = buffer.length;

    // Apply backspace control character
    backspacesCounter = 0;
    for (int i = event.length - 1; i >= 0; i--) {
      if (event[i] == 8 || event[i] == 127) {
        backspacesCounter++;
      } else {
        if (backspacesCounter > 0) {
          backspacesCounter--;
        } else {
          buffer[--bufferIndex] = event[i];
        }
      }
    }

    // Create message if there is new line character
    final chat = context.read<ChatCubit>();
    String dataString = String.fromCharCodes(buffer);
    int index = buffer.indexOf(10);
    if (~index != 0) {
      setState(() {
        chat.add(
          Message(
            1,
            backspacesCounter > 0
                ? comm.messageBuffer
                    .substring(0, comm.messageBuffer.length - backspacesCounter)
                : comm.messageBuffer + dataString.substring(0, index),
          ),
        );
        comm.messageBuffer = dataString.substring(index);
      });
    } else {
      comm.messageBuffer = (backspacesCounter > 0
          ? comm.messageBuffer
              .substring(0, comm.messageBuffer.length - backspacesCounter)
          : comm.messageBuffer + dataString);
    }
  }
}
