import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:xc/components/card_list_tile.dart';

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
          Widget result = _expansionTitle(address, context, port);
          port.dispose();

          return result;
        }),
    ];
  }

  Widget _expansionTitle(address, BuildContext context, SerialPort port) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.check_circle_outline_rounded),
        trailing: SizedBox(
          width: 180,
          child: Text(address),
        ),
        title: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            title: Text(port.description ?? "-"),
            children: [
              CardListTile(
                name: AppLocalizations.of(context)!.manufacturer,
                value: port.manufacturer,
              ),
              CardListTile(
                name: AppLocalizations.of(context)!.productName,
                value: port.productName,
              ),
              CardListTile(
                name: 'Serial Number',
                value: port.serialNumber,
              ),
              CardListTile(
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
}
