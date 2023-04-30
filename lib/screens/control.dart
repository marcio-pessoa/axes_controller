import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wakelock/wakelock.dart';
import 'package:xc/controllers/comm_bluetooth.dart';
import 'package:xc/cubit/bluetooth_cubit.dart';
import 'package:xc/cubit/chat_cubit.dart';
import 'package:xc/cubit/comm_cubit.dart';
import 'package:xc/static/comm_status.dart';

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
            child: _commIcon(),
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
  }

  Widget _commIcon() {
    Widget icon = const Icon(
      Icons.circle_outlined,
      color: Colors.grey,
    );

    switch (comm.status) {
      case CommStatus.connected:
        icon = const Icon(
          Icons.check_circle_outline_rounded,
          color: Colors.green,
        );
        break;
      case CommStatus.connecting:
        icon = const Padding(
          padding: EdgeInsets.fromLTRB(0.0, 8.0, 4.0, 8.0),
          child: SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
            ),
          ),
        );
        break;
      case CommStatus.disconnected:
        icon = const Icon(
          Icons.cancel_outlined,
          color: Colors.red,
        );
        break;
      case CommStatus.disconnecting:
        icon = const Icon(
          Icons.cancel_outlined,
          color: Colors.orange,
        );
        break;
    }
    return icon;
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
