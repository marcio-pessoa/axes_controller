import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:xc/components/radio_item.dart';
import 'package:xc/controllers/theme.dart';
import 'package:xc/cubit/bluetooth_cubit.dart';
import 'package:xc/cubit/comm_cubit.dart';
import 'package:xc/cubit/settings_cubit.dart';
import 'package:xc/static/comm_interface.dart';
import 'package:xc/static/end_line.dart';
import 'package:xc/static/languages.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  BluetoothState _bluetoothState = BluetoothState.UNKNOWN;
  String _address = "...";
  String _name = "...";

  @override
  void initState() {
    super.initState();
    // Get current state
    FlutterBluetoothSerial.instance.state.then((state) {
      setState(() {
        _bluetoothState = state;
      });
    });

    Future.doWhile(() async {
      // Wait if adapter not enabled
      if ((await FlutterBluetoothSerial.instance.isEnabled) ?? false) {
        return false;
      }
      await Future.delayed(const Duration(milliseconds: 0xDD));
      return true;
    }).then((_) {
      // Update the address field
      FlutterBluetoothSerial.instance.address.then((address) {
        setState(() {
          _address = address!;
        });
      });
    });

    FlutterBluetoothSerial.instance.name.then((name) {
      setState(() {
        _name = name!;
      });
    });

    FlutterBluetoothSerial.instance
        .onStateChanged()
        .listen((BluetoothState state) {
      setState(() {
        _bluetoothState = state;

        // Discoverable mode is disabled when Bluetooth gets disabled
        // _discoverableTimeoutTimer = null;
        // _discoverableTimeoutSecondsLeft = 0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.read<SettingsCubit>();
    final communication = context.read<CommCubit>();

    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.settings)),
      body: ListView(
        children: [
          // GeneralSettings(),
          ListTile(
            title: Text(AppLocalizations.of(context)!.communication),
          ),
          ListTile(
            title: Text(AppLocalizations.of(context)!.commInterface),
            subtitle: Text(communication.state.commInterface.description),
            leading: const Icon(Icons.usb_outlined),
            onTap: () => _commInterfaceDialog(),
          ),
          ListTile(
            title: Text(AppLocalizations.of(context)!.endLine),
            subtitle: Text(communication.state.endLine.name.toUpperCase()),
            leading: const Icon(Icons.edit_note_outlined),
            onTap: () => _endLineDialog(),
          ),
          const Divider(),
          Visibility(
            visible: communication.state.commInterface == CommInterface.serial,
            child: Column(
              children: _serialItems(context),
            ),
          ),
          Visibility(
            visible:
                communication.state.commInterface == CommInterface.bluetooth,
            child: Column(
              children: _bluetoothItems(context),
            ),
          ),
          const Divider(),
          ListTile(
            title: Text(AppLocalizations.of(context)!.interface),
          ),
          ListTile(
            title: Text(AppLocalizations.of(context)!.language),
            subtitle: Text(AppLocalizations.of(context)!.myLanguage),
            leading: const Icon(Icons.language_outlined),
            onTap: () => _languageDialog(),
          ),
          ListTile(
            title: Text(AppLocalizations.of(context)!.theme),
            subtitle: Text(themeLocaleName(context, settings.state.theme)),
            leading: const Icon(Icons.dark_mode_outlined),
            onTap: () => _themeDialog(),
          ),
          const Divider(),
          ListTile(
            title: Text(
                "${AppLocalizations.of(context)!.about} ${AppLocalizations.of(context)!.title}"),
            leading: const Icon(Icons.info_outline),
            onTap: () => Navigator.of(context).pushNamed('/about'),
          ),
        ],
      ),
    );
  }

  List<Widget> _bluetoothItems(BuildContext context) {
    final cubit = context.read<BluetoothCubit>();
    return [
      ListTile(
        title: Text(AppLocalizations.of(context)!.bluetooth),
      ),
      SwitchListTile(
        title: const Text('Enable'),
        value: _bluetoothState.isEnabled,
        onChanged: (bool value) {
          // Do the request and update with the true value then
          future() async {
            // async lambda seems to not working
            if (value) {
              await FlutterBluetoothSerial.instance.requestEnable();
            } else {
              await FlutterBluetoothSerial.instance.requestDisable();
            }
          }

          future().then((_) {
            setState(() {});
          });
        },
      ),
      ListTile(
        title: const Text('Open settings'),
        trailing: ElevatedButton(
          child: const Text('Settings'),
          onPressed: () {
            FlutterBluetoothSerial.instance.openSettings();
          },
        ),
      ),
      ListTile(
        title: const Text('Local adapter address'),
        subtitle: Text(_address),
      ),
      ListTile(
        title: const Text('Local adapter name'),
        subtitle: Text(_name),
        onLongPress: null,
      ),
      SwitchListTile(
        title: const Text('Auto-try specific pin'),
        subtitle: const Text('Pin 1234'),
        secondary: const Icon(Icons.lock_open_outlined),
        value: cubit.state.autoPairing,
        onChanged: (bool value) {
          setState(() {
            cubit.set(autoPairing: value);
          });
        },
      ),
    ];
  }

  List<Widget> _serialItems(BuildContext context) {
    return [
      ListTile(
        title: Text(AppLocalizations.of(context)!.serial),
      ),
    ];
  }

  Future<void> _languageDialog() async {
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

  Future<void> _themeDialog() async {
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

  Future<void> _endLineDialog() async {
    final cubit = context.read<CommCubit>();
    switch (await showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: Text(AppLocalizations.of(context)!.endLine),
            children: <Widget>[
              RadioItem(
                id: EndLine.cr.name.toUpperCase(),
                name: EndLine.cr.name.toUpperCase(),
                groupValue: cubit.state.endLine.name.toUpperCase(),
              ),
              RadioItem(
                id: EndLine.lf.name.toUpperCase(),
                name: EndLine.lf.name.toUpperCase(),
                groupValue: cubit.state.endLine.name.toUpperCase(),
              ),
              RadioItem(
                id: EndLine.crlf.name.toUpperCase(),
                name: EndLine.crlf.name.toUpperCase(),
                groupValue: cubit.state.endLine.name.toUpperCase(),
              ),
            ],
          );
        })) {
      case 'CR':
        cubit.set(endLine: EndLine.cr);
        break;
      case 'LF':
        cubit.set(endLine: EndLine.lf);
        break;
      case 'CRLF':
        cubit.set(endLine: EndLine.crlf);
        break;
      default:
        break;
    }
    setState(() {});
  }

  Future<void> _commInterfaceDialog() async {
    final cubit = context.read<CommCubit>();
    switch (await showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: Text(AppLocalizations.of(context)!.commInterface),
            children: <Widget>[
              RadioItem(
                id: CommInterface.bluetooth.description,
                name: CommInterface.bluetooth.description,
                groupValue: cubit.state.commInterface.description,
              ),
              RadioItem(
                id: CommInterface.serial.description,
                name: CommInterface.serial.description,
                groupValue: cubit.state.commInterface.description,
              ),
            ],
          );
        })) {
      case 'Bluetooth':
        cubit.set(commInterface: CommInterface.bluetooth);
        break;
      case 'Serial':
        cubit.set(commInterface: CommInterface.serial);
        break;
      default:
        break;
    }
    setState(() {});
  }
}
