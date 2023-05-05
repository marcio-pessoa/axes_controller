import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xc/components/messages.dart';
import 'package:xc/cubit/comm_cubit.dart';
import 'package:xc/screens/chat/bluetooth.dart';
import 'package:xc/screens/chat/serial.dart';
import 'package:xc/static/comm_interface.dart';

class Chat extends StatefulWidget {
  const Chat({super.key});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CommCubit>();

    switch (cubit.state.interface) {
      case CommInterface.bluetooth:
        return const BluetoothChat();
      case CommInterface.usb:
        return const SerialChat();
      default:
        return Message.notFound;
    }
  }
}
