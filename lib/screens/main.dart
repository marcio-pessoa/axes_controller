import 'package:flutter/material.dart';
import 'package:xc/components/drawer.dart';
import 'package:xc/general.dart';
import 'package:xc/screens/exit.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
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
      child: SafeArea(
        child: Scaffold(
          key: _scaffoldKey,
          drawer: const MyDrawer(),
          body: GeneralPage(),
        ),
      ),
    );
  }
}
