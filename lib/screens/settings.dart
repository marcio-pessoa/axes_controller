import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:xc/cubit/theme_cubit.dart';
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
            title: const Text('Theme system'),
            leading: const Icon(Icons.settings_outlined),
            onTap: () {
              final cubit = context.read<ThemeCubit>();
              cubit.setTheme(ThemeMode.system);
            },
          ),
          ListTile(
            title: const Text('Theme light'),
            leading: const Icon(Icons.settings_outlined),
            onTap: () {
              final cubit = context.read<ThemeCubit>();
              cubit.setTheme(ThemeMode.light);
            },
          ),
          ListTile(
            title: const Text('Theme dark'),
            leading: const Icon(Icons.settings_outlined),
            onTap: () {
              final cubit = context.read<ThemeCubit>();
              cubit.setTheme(ThemeMode.dark);
            },
          ),
        ],
      ),
    );
  }
}
