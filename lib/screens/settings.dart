import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:xc/components/radio_item.dart';
import 'package:xc/cubit/settings_cubit.dart';
import 'package:xc/general.dart';
import 'package:xc/static/languages.dart';

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
            title: Text(AppLocalizations.of(context)!.language),
            subtitle: Text(AppLocalizations.of(context)!.myLanguage),
            leading: const Icon(Icons.language_outlined),
            onTap: () => languageDialog(),
          ),
          ListTile(
            title: Text(AppLocalizations.of(context)!.theme),
            subtitle: Text(themeName()),
            leading: const Icon(Icons.dark_mode_outlined),
            onTap: () => themeDialog(),
          ),
        ],
      ),
    );
  }

  Future<void> themeDialog() async {
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
                groupValue: cubit.state.theme.name,
              ),
              RadioItem(
                id: 'dark',
                name: AppLocalizations.of(context)!.themeDark,
                groupValue: cubit.state.theme.name,
              ),
              RadioItem(
                id: 'system',
                name: AppLocalizations.of(context)!.systemDefault,
                groupValue: cubit.state.theme.name,
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
      case 'system':
        cubit.set(theme: ThemeMode.system);
        break;
      default:
        break;
    }
    setState(() {});
  }

  Future<void> languageDialog() async {
    final cubit = context.read<SettingsCubit>();
    switch (await showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: Text(AppLocalizations.of(context)!.chooseLanguage),
            children: <Widget>[
              RadioItem(
                id: 'en',
                name: AppLocalizations.of(context)!.english,
                groupValue: cubit.state.locale.languageCode,
              ),
              RadioItem(
                id: 'pt',
                name: AppLocalizations.of(context)!.portuguese,
                groupValue: cubit.state.locale.languageCode,
              ),
            ],
          );
        })) {
      case 'en':
        cubit.set(locale: AppLocale.en);
        break;
      case 'pt':
        cubit.set(locale: AppLocale.pt);
        break;
      default:
        break;
    }
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
