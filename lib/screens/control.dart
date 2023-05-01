import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wakelock/wakelock.dart';
import 'package:xc/components/comm_status_icon.dart';
import 'package:xc/controllers/comm_bluetooth.dart';
import 'package:xc/cubit/bluetooth_cubit.dart';
import 'package:xc/cubit/chat_cubit.dart';
import 'package:xc/cubit/comm_cubit.dart';

class Control extends StatefulWidget {
  const Control({super.key});

  @override
  State<Control> createState() => _ControlState();
}

class _ControlState extends State<Control> {
  final Comm comm = Comm();

  @override
  void initState() {
    super.initState();
    Wakelock.enable();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    _initComm();
  }

  @override
  void dispose() {
    Wakelock.disable();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    DeviceOrientation.portraitUp;
    comm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.control),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CommStatusIcon(status: comm.status),
          )
        ],
      ),
      body: Row(
        children: [
          _controlPad(),
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
    } else {
      comm.messageBuffer = (backspacesCounter > 0
          ? comm.messageBuffer
              .substring(0, comm.messageBuffer.length - backspacesCounter)
          : comm.messageBuffer + dataString);
    }
  }

  Expanded _controlPad() {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  _controlButton("assets/arrow_up.png", 'G21', 'M00'),
                ],
              ),
              Row(
                children: [
                  _controlButton("assets/arrow_left.png", 'G41', 'M00'),
                  _controlButton("assets/stop.png", 'M00', 'M00'),
                  _controlButton("assets/arrow_right.png", 'G42', 'M00'),
                ],
              ),
              Row(
                children: [
                  _controlButton("assets/arrow_down.png", 'G22', 'M00'),
                ],
              ),
            ],
          ),
          _controlButton("assets/stop.png", 'M93', ''),
        ],
      ),
    );
  }

  Padding _controlButton(String image, String commandDown, String commandUp) {
    final cubit = context.read<ChatCubit>();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Listener(
        onPointerDown: (details) {
          cubit.add(Message(comm.clientID, commandDown));
          comm.send(commandDown);
        },
        onPointerUp: (details) {
          cubit.add(Message(comm.clientID, commandDown));
          comm.send(commandUp);
        },
        child: ColorFiltered(
            colorFilter: ColorFilter.mode(
              Colors.teal.withOpacity(0.0),
              BlendMode.color,
            ),
            child: Image(image: AssetImage(image))),
      ),
    );
  }
}
