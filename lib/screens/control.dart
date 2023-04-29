import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wakelock/wakelock.dart';
import 'package:xc/controllers/comm_bluetooth.dart';
import 'package:xc/cubit/bluetooth_cubit.dart';
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
    final device = context.read<BluetoothCubit>();
    final preferences = context.read<CommCubit>();
    comm.init(device, preferences);
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
        actions: [commStatus()],
      ),
      body: Row(
        children: [controlPad()],
      ),
    );
  }

  Padding commStatus() {
    Color color = comm.isConnected ? Colors.green : Colors.grey;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Icon(
        Icons.circle,
        color: color,
      ),
    );
  }

  Expanded controlPad() {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  controlButton("assets/arrow_up.png", 'G21', 'M00'),
                ],
              ),
              Row(
                children: [
                  controlButton("assets/arrow_left.png", 'G41', 'M00'),
                  controlButton("assets/stop.png", 'M00', 'M00'),
                  controlButton("assets/arrow_right.png", 'G42', 'M00'),
                ],
              ),
              Row(
                children: [
                  controlButton("assets/arrow_down.png", 'G22', 'M00'),
                ],
              ),
            ],
          ),
          controlButton("assets/stop.png", 'M93', ''),
        ],
      ),
    );
  }

  Padding controlButton(String image, String commandDown, String commandUp) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Listener(
        onPointerDown: (details) => comm.send(commandDown),
        onPointerUp: (details) => comm.send(commandUp),
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
