import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:xc/components/drawer.dart';
import 'package:xc/screens/exit.dart';

class Control extends StatefulWidget {
  const Control({super.key});

  @override
  State<Control> createState() => _ControlState();
}

class _ControlState extends State<Control> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
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
          children: [
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon:
                          const Image(image: AssetImage("assets/arrow_up.png")),
                      onPressed: () {},
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Image(
                          image: AssetImage("assets/arrow_left.png")),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Image(image: AssetImage("assets/stop.png")),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Image(
                          image: AssetImage("assets/arrow_right.png")),
                      onPressed: () {},
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Image(
                          image: AssetImage("assets/arrow_down.png")),
                      onPressed: () {},
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
