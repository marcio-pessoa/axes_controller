import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:xc/controllers/string.dart';

class About extends StatefulWidget {
  const About({Key? key}) : super(key: key);

  @override
  State<About> createState() => _AboutState();
}

class _AboutState extends State<About> {
  String appVersion = '';

  @override
  void initState() {
    super.initState();
    _appInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.about)),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text(AppLocalizations.of(context)!.appVersion),
            subtitle:
                Text('${AppLocalizations.of(context)!.title} $appVersion'),
            leading: const Icon(Icons.perm_device_information_rounded),
          ),
          const Divider(),
          ListTile(
            title: Text(AppLocalizations.of(context)!.runningOn),
            subtitle: Text(
                "${Platform.operatingSystem.capitalize()}; Build/${Platform.operatingSystemVersion}"),
            leading: const Icon(Icons.auto_awesome_outlined),
            onTap: () {
              Navigator.of(context).pushNamed('/about/deviceDetails');
            },
          ),
          const Divider(),
          ListTile(
            title: Text(AppLocalizations.of(context)!.legalInfo),
            subtitle: Text(AppLocalizations.of(context)!.legalData),
            leading: const Icon(Icons.balance_outlined),
          ),
        ],
      ),
    );
  }

  Future _appInfo() async {
    // final PackageInfo result = await PackageInfo.fromPlatform();

    // setState(() {
    //   appVersion = '${result.version}, Build/${result.buildNumber}';
    // });
  }
}
