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
                IconButton(
                  icon: const Image(image: AssetImage("assets/arrow_up.png")),
                  onPressed: () {
                    comm.send('G21');
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Image(image: AssetImage("assets/arrow_left.png")),
                  onPressed: () {
                    comm.send('G41');
                  },
                ),
                IconButton(
                  icon: const Image(image: AssetImage("assets/stop.png")),
                  onPressed: () {
                    comm.send('M00');
                  },
                ),
                IconButton(
                  icon:
                      const Image(image: AssetImage("assets/arrow_right.png")),
                  onPressed: () {
                    comm.send('G42');
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Image(image: AssetImage("assets/arrow_down.png")),
                  onPressed: () {
                    comm.send('G22');
                  },
                ),
              ],
            ),
          ],
        ),
        const Padding(padding: EdgeInsets.only(right: 100)),
        IconButton(
          icon: const Image(image: AssetImage("assets/stop.png")),
          onPressed: () {
            comm.send('M93');
          },
        ),
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
}
