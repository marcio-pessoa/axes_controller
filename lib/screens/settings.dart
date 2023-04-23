import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:xc/components/comm_interface_icon.dart';
import 'package:xc/components/radio_item.dart';
import 'package:xc/controllers/theme.dart';
import 'package:xc/cubit/bluetooth_cubit.dart';
import 'package:xc/cubit/comm_cubit.dart';
import 'package:xc/cubit/serial_cubit.dart';
import 'package:xc/cubit/settings_cubit.dart';
import 'package:xc/static/baud_rate.dart';
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
          ListTile(
            title: Text(AppLocalizations.of(context)!.communication),
          ),
          ListTile(
            title: Text(AppLocalizations.of(context)!.commInterface),
            subtitle: Text(communication.state.commInterface.description),
            leading: CommInterfaceIcon(
              interface: communication.state.commInterface,
            ),
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
            visible: communication.state.commInterface == CommInterface.usb,
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
        title: Text(AppLocalizations.of(context)!.enable),
        value: _bluetoothState.isEnabled,
        secondary: const Icon(Icons.check_box_outlined),
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
        title: Text(AppLocalizations.of(context)!.openSettings),
        leading: const Icon(Icons.settings_applications_outlined),
        trailing: ElevatedButton(
          child: Text(AppLocalizations.of(context)!.settings),
          onPressed: () {
            FlutterBluetoothSerial.instance.openSettings();
          },
        ),
      ),
      ListTile(
        title: Text(AppLocalizations.of(context)!.localAdapterAddress),
        subtitle: Text(_address),
        leading: const Icon(Icons.numbers_outlined),
      ),
      ListTile(
        title: Text(AppLocalizations.of(context)!.localAdapterName),
        subtitle: Text(_name),
        leading: const Icon(Icons.abc_outlined),
        onLongPress: null,
      ),
      SwitchListTile(
        title: Text(AppLocalizations.of(context)!.autoTrySpecificPin),
        subtitle: Text('Pin ${cubit.state.defaultPassword}'),
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
    final cubit = context.read<SerialCubit>();
    return [
      ListTile(
        title: Text(AppLocalizations.of(context)!.serial),
      ),
      ListTile(
        title: Text(AppLocalizations.of(context)!.baudRate),
        subtitle: Text("${cubit.state.baudRate.description} Bauds"),
        leading: const Icon(Icons.speed_outlined),
        onTap: () => _baudRateDialog(),
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
                id: CommInterface.usb.description,
                name: CommInterface.usb.description,
                groupValue: cubit.state.commInterface.description,
              ),
            ],
          );
        })) {
      case 'Bluetooth':
        cubit.set(commInterface: CommInterface.bluetooth);
        break;
      case 'USB':
        cubit.set(commInterface: CommInterface.usb);
        break;
      default:
        break;
    }
    setState(() {});
  }

  Future<void> _baudRateDialog() async {
    final cubit = context.read<SerialCubit>();
    switch (await showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: Text("${AppLocalizations.of(context)!.baudRate} (Bauds)"),
            children: <Widget>[
              RadioItem(
                id: BaudRate.baud1200.description,
                name: BaudRate.baud1200.description,
                groupValue: cubit.state.baudRate.description,
              ),
              RadioItem(
                id: BaudRate.baud2400.description,
                name: BaudRate.baud2400.description,
                groupValue: cubit.state.baudRate.description,
              ),
              RadioItem(
                id: BaudRate.baud4800.description,
                name: BaudRate.baud4800.description,
                groupValue: cubit.state.baudRate.description,
              ),
              RadioItem(
                id: BaudRate.baud9600.description,
                name: BaudRate.baud9600.description,
                groupValue: cubit.state.baudRate.description,
              ),
              RadioItem(
                id: BaudRate.baud19200.description,
                name: BaudRate.baud19200.description,
                groupValue: cubit.state.baudRate.description,
              ),
              RadioItem(
                id: BaudRate.baud38400.description,
                name: BaudRate.baud38400.description,
                groupValue: cubit.state.baudRate.description,
              ),
              RadioItem(
                id: BaudRate.baud57600.description,
                name: BaudRate.baud57600.description,
                groupValue: cubit.state.baudRate.description,
              ),
              RadioItem(
                id: BaudRate.baud115200.description,
                name: BaudRate.baud115200.description,
                groupValue: cubit.state.baudRate.description,
              ),
            ],
          );
        })) {
      case '1200':
        cubit.set(baudRate: BaudRate.baud1200);
        break;
      case '2400':
        cubit.set(baudRate: BaudRate.baud2400);
        break;
      case '4800':
        cubit.set(baudRate: BaudRate.baud4800);
        break;
      case '9600':
        cubit.set(baudRate: BaudRate.baud9600);
        break;
      case '19200':
        cubit.set(baudRate: BaudRate.baud19200);
        break;
      case '38400':
        cubit.set(baudRate: BaudRate.baud38400);
        break;
      case '57600':
        cubit.set(baudRate: BaudRate.baud57600);
        break;
      case '115200':
        cubit.set(baudRate: BaudRate.baud115200);
        break;
      default:
        break;
    }
    setState(() {});
  }
}
