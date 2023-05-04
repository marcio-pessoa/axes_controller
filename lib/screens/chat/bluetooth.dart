import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xc/components/chat_app_bar.dart';
import 'package:xc/components/chat_messages.dart';
import 'package:xc/components/chat_clear_dialog.dart';
import 'package:xc/components/chat_text_field.dart';
import 'package:xc/components/scroll_follow.dart';
import 'package:xc/controllers/comm_bluetooth.dart';
import 'package:xc/cubit/bluetooth_cubit.dart';
import 'package:xc/cubit/chat_cubit.dart';
import 'package:xc/cubit/comm_cubit.dart';
import 'package:xc/static/comm_message.dart';

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
    return Scaffold(
      appBar: ChatAppBar(status: comm.status, clearDialog: _clearDialog),
      body: Column(
        children: <Widget>[
          ChatMessages(scrollController: _listScrollController),
          ChatUserInput(
            sender: _send,
            name: comm.device.state.connection.name,
            status: comm.status,
            focusNode: textEditingFocusNode,
            textEditingController: textEditingController,
          ),
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
          debugPrint("Desconectado localmente!");
        } else {
          debugPrint("Desconectado remotamente!");
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
      debugPrint(error.toString());
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
