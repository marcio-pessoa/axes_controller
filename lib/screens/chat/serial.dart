import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:xc/components/comm_status_icon.dart';
import 'package:xc/controllers/comm_serial.dart';
import 'package:xc/controllers/hint_text.dart';
import 'package:xc/cubit/chat_cubit.dart';
import 'package:xc/cubit/comm_cubit.dart';
import 'package:xc/cubit/serial_cubit.dart';
import 'package:xc/static/colors.dart';
import 'package:xc/static/comm_status.dart';

class SerialChat extends StatefulWidget {
  const SerialChat({super.key});

  @override
  State<SerialChat> createState() => _SerialChatState();
}

class _SerialChatState extends State<SerialChat> {
  final TextEditingController textEditingController = TextEditingController();
  final ScrollController _listScrollController = ScrollController();
  CommSerial comm = CommSerial();

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

    String hint = hintText(context, comm.port.name.toString(), comm.status);

    return Scaffold(
      appBar: AppBar(
        title: (Text(AppLocalizations.of(context)!.chat)),
        actions: <Widget>[
          CommStatusIcon(status: comm.status),
          IconButton(
            icon: const Icon(Icons.speaker_notes_off_outlined),
            onPressed: _clearChatDialog,
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          Flexible(
            child: ListView(
              padding: const EdgeInsets.all(12.0),
              controller: _listScrollController,
              // children: list,
            ),
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
                      hintText: hint,
                      hintStyle: const TextStyle(color: Colors.grey),
                    ),
                    enabled: comm.status == CommStatus.connected,
                  ),
                ),
              ),
              // Container(
              //   margin: const EdgeInsets.all(8.0),
              //   child: IconButton(
              //       icon: const Icon(Icons.send),
              //       onPressed: comm.isConnected ? () => _send() : null),
              // ),
            ],
          )
        ],
      ),
    );
  }

  _initComm() async {
    final device = context.read<SerialCubit>();
    final preferences = context.read<CommCubit>();

    await comm.init(device, preferences);

    setState(() {});

    if (comm.status == CommStatus.connected) {
      Stream<String> upcommingData = comm.reader.stream.map((event) {
        return String.fromCharCodes(event);
      });

      upcommingData.listen((event) {
        _receive(event);
      });

      if (mounted) {
        setState(() {});
      }
    }
  }

  void _send() {}

  void _receive(event) {
    debugPrint('Read data: $event');
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
