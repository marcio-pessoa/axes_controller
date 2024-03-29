import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:xc/components/comm_interface_icon.dart';
import 'package:xc/cubit/comm_cubit.dart';
import 'package:xc/screens/exit.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {
    final communication = context.read<CommCubit>();

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: const BoxDecoration(color: Colors.blue),
            child: Text(
              AppLocalizations.of(context)!.title,
              style: const TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          ListTile(
            title: Text(AppLocalizations.of(context)!.selectDevice),
            leading:
                CommInterfaceIcon(interface: communication.state.interface),
            onTap: () {
              Navigator.of(context).pushNamed('/selectDevice');
            },
          ),
          ListTile(
            title: Text(AppLocalizations.of(context)!.control),
            leading: const Icon(Icons.control_camera_outlined),
            onTap: () {
              Navigator.of(context).pushNamed('/control');
            },
          ),
          ListTile(
            title: Text(AppLocalizations.of(context)!.chat),
            leading: const Icon(Icons.chat_outlined),
            onTap: () {
              Navigator.of(context).pushNamed('/chat');
            },
          ),
          const Divider(),
          ListTile(
            title: Text(AppLocalizations.of(context)!.settings),
            leading: const Icon(Icons.settings_outlined),
            onTap: () {
              Navigator.of(context).pushNamed('/settings');
            },
          ),
          _systemBasedContent(context),
        ],
      ),
    );
  }

  Column _systemBasedContent(BuildContext context) {
    return Platform.isLinux
        ? Column(
            children: [
              const Divider(),
              ListTile(
                title: Text(AppLocalizations.of(context)!.exit),
                leading: const Icon(Icons.exit_to_app_rounded),
                onTap: () {
                  exitDialog(context);
                },
              ),
            ],
          )
        : const Column();
  }
}
