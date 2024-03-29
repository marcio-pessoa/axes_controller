import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:xc/controllers/string.dart';
import 'package:xc/static/external_link.dart';

class About extends StatefulWidget {
  const About({super.key});

  @override
  State<About> createState() => _AboutState();
}

class _AboutState extends State<About> {
  String appVersion = '';
  String licenseString = '';

  @override
  void initState() {
    super.initState();

    _getPackageInfo();
    _loadLicenseString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${AppLocalizations.of(context)!.about} ${AppLocalizations.of(context)!.title}',
        ),
      ),
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
            title: Text(AppLocalizations.of(context)!.contactUs),
            subtitle: Text(AppLocalizations.of(context)!.github),
            leading: const Icon(Icons.message_outlined),
            onTap: () async => await launchUrl(ExternalLink.github.uri),
          ),
          const Divider(),
          ListTile(
            title: Text(AppLocalizations.of(context)!.license),
            subtitle: Text(AppLocalizations.of(context)!.licenseInfo),
            leading: const Icon(Icons.library_books_outlined),
            onTap: _licenseModalBottomSheet,
          ),
          ListTile(
            title: Text(AppLocalizations.of(context)!.ossLicenses),
            subtitle: Text(AppLocalizations.of(context)!.licenses),
            leading: const Icon(Icons.menu_book_outlined),
            onTap: () => Navigator.of(context).pushNamed('/about/ossLicenses'),
          ),
          ListTile(
            title: Text(AppLocalizations.of(context)!.legalInfo),
            subtitle: Text(AppLocalizations.of(context)!.legalData),
            leading: const Icon(Icons.balance_outlined),
          ),
        ],
      ),
    );
  }

  Future _getPackageInfo() async {
    final PackageInfo result = await PackageInfo.fromPlatform();

    setState(() {
      appVersion = '${result.version}, Build/${result.buildNumber}';
    });
  }

  Future _loadLicenseString() async {
    licenseString = await DefaultAssetBundle.of(context).loadString('LICENSE');
  }

  _licenseModalBottomSheet() {
    return showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 1,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: ListView(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(licenseString),
                      ElevatedButton(
                        child: Text(AppLocalizations.of(context)!.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
