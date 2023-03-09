import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:xc/SelectBondedDevicePage.dart';
import 'package:xc/screens/chat.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  Future<void> openChat(BuildContext context) async {
    final BluetoothDevice? selectedDevice = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return const SelectBondedDevicePage(checkAvailability: false);
        },
      ),
    );

    if (selectedDevice != null) {
      print('Connect -> selected ' + selectedDevice.address);
      _startChat(context, selectedDevice);
    } else {
      print('Connect -> no device selected');
    }
  }

  void _startChat(BuildContext context, BluetoothDevice server) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return ChatPage(server: server);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          ListTile(
            title: Text(AppLocalizations.of(context)!.chat),
            leading: const Icon(Icons.chat),
            onTap: () {
              openChat(context);
              // Navigator.of(context).pushReplacementNamed('/analysis'); //TODO
            },
          ),
          const Divider(),
          ListTile(
            title: Text(AppLocalizations.of(context)!.settings),
            leading: const Icon(Icons.settings_outlined),
            onTap: () {
              Navigator.of(context).pushNamed('/settings'); //TODO
            },
          ),
        ],
      ),
    );
  }
}
