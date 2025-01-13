import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:xc/components/drawer.dart';
import 'package:xc/cubit/comm_cubit.dart';
import 'package:xc/screens/exit.dart';
import 'package:xc/static/comm_interface.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    _detectHostPlatform();

    var child = Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.title)),
      key: _scaffoldKey,
      drawer: const MyDrawer(),
      body: Container(),
    );

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, dynamic) {
        if (didPop) {
          return;
        }
        exitDialog(context);
      },
      child: child,
    );
  }

  void _detectHostPlatform() {
    final cubit = context.read<CommCubit>();

    if (Platform.isAndroid) {
      cubit.set(interface: CommInterface.bluetooth);
    } else if (Platform.isLinux || Platform.isMacOS || Platform.isWindows) {
      cubit.set(interface: CommInterface.usb);
    }
  }
}
