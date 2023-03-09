import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          ListTile(
            title: Text(AppLocalizations.of(context)!.control),
            leading: const Icon(Icons.search_outlined),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/analysis'); //TODO
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
