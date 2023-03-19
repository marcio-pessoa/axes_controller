import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:xc/components/radio_item.dart';
import 'package:xc/cubit/settings_cubit.dart';
import 'package:xc/general.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.settings)),
      body: ListView(
        children: [
          GeneralSettings(),
          const Divider(),
          ListTile(
            title: Text(AppLocalizations.of(context)!.theme),
            subtitle: Text(themeName()),
            leading: const Icon(Icons.settings_outlined),
            onTap: () {
              themeDialog(context);
            },
          ),
          // const Divider(),
          // ListTile(
          //   title: const Text('Language system'),
          //   leading: const Icon(Icons.settings_outlined),
          //   onTap: () {
          //     final cubit = context.read<SettingsCubit>();
          //     cubit.set(theme: ThemeMode.system);
          //   },
          // ),
          // ListTile(
          //   title: const Text('Português'),
          //   leading: const Icon(Icons.settings_outlined),
          //   onTap: () {
          //     final cubit = context.read<SettingsCubit>();
          //     cubit.set(locale: AppLocale.pt);
          //   },
          // ),
          // ListTile(
          //   title: const Text('Inglês'),
          //   leading: const Icon(Icons.settings_outlined),
          //   onTap: () {
          //     final cubit = context.read<SettingsCubit>();
          //     cubit.set(locale: AppLocale.en);
          //   },
          // ),
        ],
      ),
    );
  }

  Future<void> themeDialog(BuildContext context) async {
    final cubit = context.read<SettingsCubit>();
    switch (await showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: Text(AppLocalizations.of(context)!.chooseTheme),
            children: <Widget>[
              RadioItem(
                id: 'light',
                name: AppLocalizations.of(context)!.themeLight,
                groupValue: "theme",
              ),
              RadioItem(
                id: 'dark',
                name: AppLocalizations.of(context)!.themeDark,
                groupValue: "theme",
              ),
              RadioItem(
                id: 'system',
                name: AppLocalizations.of(context)!.systemDefault,
                groupValue: "theme",
              ),
            ],
          );
        })) {
      case 'light':
        cubit.set(theme: ThemeMode.light);
        break;
      case 'dark':
        cubit.set(theme: ThemeMode.dark);
        break;
      default:
        cubit.set(theme: ThemeMode.system);
        break;
    }
    setState(() {});
  }

  themeName() {
    final cubit = context.read<SettingsCubit>();
    switch (cubit.state.theme) {
      case ThemeMode.light:
        return AppLocalizations.of(context)!.themeLight;
      case ThemeMode.dark:
        return AppLocalizations.of(context)!.themeDark;
      case ThemeMode.system:
        return AppLocalizations.of(context)!.systemDefault;
    }
  }
}
