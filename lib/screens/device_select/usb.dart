import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:xc/components/detailed_list_tile.dart';
import 'package:xc/cubit/serial_cubit.dart';
import 'package:xc/static/colors.dart';

extension IntToString on int {
  String toHex() => '0x${toRadixString(16)}';
  String toPadded([int width = 3]) => toString().padLeft(width, '0');
  String toTransport() {
    switch (this) {
      case SerialPortTransport.usb:
        return 'USB';
      case SerialPortTransport.bluetooth:
        return 'Bluetooth';
      case SerialPortTransport.native:
        return 'Native';
      default:
        return 'Unknown';
    }
  }
}

class DeviceSelectUSB extends StatefulWidget {
  const DeviceSelectUSB({super.key});

  @override
  State<DeviceSelectUSB> createState() => _DeviceSelectUSBState();
}

class _DeviceSelectUSBState extends State<DeviceSelectUSB> {
  var availablePorts = [];

  @override
  void initState() {
    super.initState();
    scanPorts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.selectDevice),
      ),
      body: ListView(children: _deviceList),
      floatingActionButton: FloatingActionButton(
        onPressed: scanPorts,
        child: const Icon(Icons.refresh),
      ),
    );
  }

  List<Widget> get _deviceList {
    return [
      for (final address in availablePorts)
        Builder(builder: (context) {
          final port = SerialPort(address);
          Widget result = _serialTile(address, port);
          port.dispose();

          return result;
        }),
    ];
  }

  Card _serialTile(String? address, SerialPort port) {
    final cubit = context.read<SerialCubit>();
    Icon icon = const Icon(Icons.radio_button_unchecked_outlined);
    if (address == cubit.state.address) {
      icon = const Icon(
        Icons.check_circle_outline_rounded,
        color: MyColors.ok,
      );
    }

    return Card(
      child: ListTile(
        leading: IconButton(
          onPressed: () => onPressed(address),
          icon: icon,
        ),
        trailing: SizedBox(width: 180, child: Text(address.toString())),
        title: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            title: Text(port.description ?? "-"),
            children: [
              DetailedListTile(
                name: AppLocalizations.of(context)!.manufacturer,
                value: port.manufacturer,
              ),
              DetailedListTile(
                name: AppLocalizations.of(context)!.productName,
                value: port.productName,
              ),
              DetailedListTile(
                name: 'Serial Number',
                value: port.serialNumber,
              ),
              DetailedListTile(
                name: 'MAC Address',
                value: port.macAddress,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void scanPorts() {
    setState(() => availablePorts = SerialPort.availablePorts);
  }

  onPressed(String? address) {
    final cubit = context.read<SerialCubit>();
    setState(() {
      cubit.set(address: address);
      log("-- address hydrated cubit: ${cubit.state.address}");
    });
  }
}
