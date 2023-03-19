import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:xc/controllers/device_info.dart';

class DeviceDetails extends StatefulWidget {
  const DeviceDetails({super.key});

  @override
  State<DeviceDetails> createState() => _DeviceDetailsState();
}

class _DeviceDetailsState extends State<DeviceDetails> {
  Map<String, dynamic> deviceData = <String, dynamic>{};

  @override
  void initState() {
    super.initState();
    _deviceInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.runningOn)),
      body: ListView(
        children: deviceData.keys.map(
          (String property) {
            var data = deviceData[property];
            String content = data.toString();
            if (data is List) {
              content = data.join('\n');
            }

            return ListTile(
              title: Text(property),
              subtitle: Text(
                content,
                // maxLines: 10,
                // overflow: TextOverflow.ellipsis,
              ),
            );
          },
        ).toList(),
      ),
    );
  }

  Future _deviceInfo() async {
    final DeviceInfo deviceInfo = DeviceInfo();
    final Map<String, dynamic> result = await deviceInfo.run();

    setState(() {
      deviceData = result;
    });
  }
}
