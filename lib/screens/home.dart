import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:xc/components/drawer.dart';
import 'package:xc/general.dart';
import 'package:xc/screens/exit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
          appBar: AppBar(title: Text(AppLocalizations.of(context)!.title)),
          key: _scaffoldKey,
          drawer: const MyDrawer(),
          body: GeneralPage(),
        ),
      ),
    );
  }
}
