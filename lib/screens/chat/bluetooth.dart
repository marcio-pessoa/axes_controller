import 'dart:async';
import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:xc/components/clear_chat_dialog.dart';
import 'package:xc/components/comm_status_icon.dart';
import 'package:xc/components/scroll_follow.dart';
import 'package:xc/controllers/comm_bluetooth.dart';
import 'package:xc/controllers/hint_text.dart';
import 'package:xc/cubit/bluetooth_cubit.dart';
import 'package:xc/cubit/chat_cubit.dart';
import 'package:xc/cubit/comm_cubit.dart';
import 'package:xc/static/colors.dart';
import 'package:xc/static/comm_message.dart';
import 'package:xc/static/comm_status.dart';

class BluetoothChat extends StatefulWidget {
  const BluetoothChat({super.key});

  @override
  State<BluetoothChat> createState() => _Chat();
}

class _Chat extends State<BluetoothChat> {
  final TextEditingController textEditingController = TextEditingController();
  final FocusNode textEditingFocusNode = FocusNode();
  final ScrollController _listScrollController = ScrollController();
  Comm comm = Comm();

  @override
  void initState() {
    super.initState();
    textEditingFocusNode.requestFocus();
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
          Flexible(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 4000),
              child: Container(
                padding: const EdgeInsets.all(12.0),
                margin:
                    const EdgeInsets.only(bottom: 8.0, left: 8.0, right: 8.0),
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
            ),
          ),
        ],
      );
    }).toList();

    final serverName = comm.device.state.connection.name ??
        AppLocalizations.of(context)!.unknown;

    String hint = hintText(context, serverName, comm.status);

    return Scaffold(
      appBar: AppBar(
        title: (Text(AppLocalizations.of(context)!.chat)),
        actions: <Widget>[
          CommStatusIcon(status: comm.status),
          IconButton(
            icon: const Icon(Icons.speaker_notes_off_outlined),
            onPressed: _clearDialog,
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          Flexible(
            child: ListView(
              padding: const EdgeInsets.all(12.0),
              controller: _listScrollController,
              children: list,
            ),
          ),
          Container(
            color: Colors.grey.withAlpha(32),
            child: Row(
              children: <Widget>[
                Flexible(
                  child: ListTile(
                    title: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        style: const TextStyle(fontSize: 15.0),
                        textInputAction: TextInputAction.go,
                        controller: textEditingController,
                        focusNode: textEditingFocusNode,
                        decoration: InputDecoration.collapsed(
                          hintText: hint,
                          hintStyle: const TextStyle(color: Colors.grey),
                        ),
                        enabled: comm.status == CommStatus.connected,
                        onSubmitted: (value) => _send(),
                        onChanged: (value) => setState(() {}),
                      ),
                    ),
                    trailing: Visibility(
                      visible: textEditingController.text.isNotEmpty,
                      child: IconButton(
                        icon: const Icon(Icons.send, color: MyColors.primary),
                        onPressed: () => _send(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
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

    scrollFollow(_listScrollController);
  }

  void _send() async {
    final text = textEditingController.text.trim();

    textEditingFocusNode.requestFocus();

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

      scrollFollow(_listScrollController);
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
      scrollFollow(_listScrollController);
    } else {
      comm.messageBuffer = (backspacesCounter > 0
          ? comm.messageBuffer
              .substring(0, comm.messageBuffer.length - backspacesCounter)
          : comm.messageBuffer + dataString);
    }
  }

  Future<void> _clearDialog() async {
    await clearChatDialog(context);
    setState(() {});
    textEditingFocusNode.requestFocus();
  }
}
