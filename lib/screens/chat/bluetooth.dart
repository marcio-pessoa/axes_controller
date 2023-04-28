import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:xc/controllers/comm_bluetooth.dart';
import 'package:xc/cubit/bluetooth_cubit.dart';
import 'package:xc/cubit/comm_cubit.dart';

class ChatBluetooth extends StatefulWidget {
  const ChatBluetooth({super.key});

  @override
  State<ChatBluetooth> createState() => _Chat();
}

class _Chat extends State<ChatBluetooth> {
  Comm comm = Comm();

  final TextEditingController textEditingController = TextEditingController();
  final ScrollController listScrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    final device = context.read<BluetoothCubit>();
    final preferences = context.read<CommCubit>();

    comm.init(device, preferences);

    setState(() {
      //TODO: Is it really necessary?
      comm.isConnecting;
      comm.isDisconnecting;
    });
  }

  @override
  void dispose() {
    comm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<BluetoothCubit>();

    final List<Row> list = comm.messages.map((message) {
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

    final serverName = cubit.state.connection.name ?? "Unknown";
    return Scaffold(
      appBar: AppBar(
          title: (comm.isConnecting
              ? Text(
                  "${AppLocalizations.of(context)!.chatConnecting}$serverName...")
              : comm.isConnected
                  ? Text('Live chat with $serverName')
                  : Text('Chat log with $serverName'))),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Flexible(
              child: ListView(
                  padding: const EdgeInsets.all(12.0),
                  controller: listScrollController,
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
                        hintText: comm.isConnecting
                            ? AppLocalizations.of(context)!.waitConnection
                            : comm.isConnected
                                ? AppLocalizations.of(context)!.typeMessage
                                : AppLocalizations.of(context)!.chatDetached,
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
                      onPressed: comm.isConnected
                          ? () => _sendMessage(textEditingController.text)
                          : null),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void _sendMessage(String text) async {
    text = text.trim();
    textEditingController.clear();

    if (text.isNotEmpty) {
      try {
        comm.send(text);

        setState(() {
          comm.messages.add(Message(comm.clientID, text));
        });

        Future.delayed(const Duration(milliseconds: 333)).then((_) {
          listScrollController.animateTo(
              listScrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 333),
              curve: Curves.easeOut);
        });
      } catch (e) {
        // Ignore error, but notify state
        setState(() {});
      }
    }
  }
}
