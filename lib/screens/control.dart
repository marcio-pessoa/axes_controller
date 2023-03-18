import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:xc/comm.dart';
import 'package:xc/components/drawer.dart';
import 'package:xc/cubit/bluetooth_cubit.dart';
import 'package:xc/screens/exit.dart';

class Control extends StatefulWidget {
  const Control({super.key});

  @override
  State<Control> createState() => _ControlState();
}

class _ControlState extends State<Control> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final Comm comm = Comm();

  var _counter = 0;
  bool _buttonPressed = false;
  bool _loopActive = false;

  @override
  void initState() {
    final cubit = context.read<BluetoothCubit>();
    comm.start(cubit.state.connection);
    super.initState();
  }

  @override
  void dispose() {
    comm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var joystick = Row(
      children: [
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                joypadButton("assets/arrow_up.png", 'G21', 'M00'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                joypadButton("assets/arrow_left.png", 'G41', 'M00'),
                joypadButton("assets/stop.png", 'M00', 'M00'),
                joypadButton("assets/arrow_right.png", 'G42', 'M00'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                joypadButton("assets/arrow_down.png", 'G22', 'M00'),
              ],
            ),
          ],
        ),
        const Padding(padding: EdgeInsets.only(right: 10)),
        joypadButton("assets/stop.png", 'M93', 'M93'),
      ],
    );

    return WillPopScope(
      onWillPop: () async {
        if (_scaffoldKey.currentState!.isDrawerOpen) {
          Navigator.of(context).pop();
          return false;
        }
        return exitDialog(context);
      },
      child: Scaffold(
        appBar: AppBar(title: Text(AppLocalizations.of(context)!.control)),
        key: _scaffoldKey,
        drawer: const MyDrawer(),
        body: Row(
          children: [joystick],
        ),
      ),
    );
  }

  Padding joypadButton(String image, String commandDown, String commandUp) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Listener(
        onPointerDown: (details) => comm.send(commandDown),
        onPointerUp: (details) => comm.send(commandUp),
        child: Image(image: AssetImage(image)),
      ),
    );
  }
}
