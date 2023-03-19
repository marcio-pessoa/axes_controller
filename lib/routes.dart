import 'package:xc/SelectBondedDevicePage.dart';
import 'package:xc/screens/about.dart';
import 'package:xc/screens/control.dart';
import 'package:xc/screens/device_details.dart';
import 'package:xc/screens/home.dart';
import 'package:xc/screens/settings.dart';

var routes = {
  '/': (context) => const HomeScreen(),
  '/about': (context) => const About(),
  '/about/deviceDetails': (context) => const DeviceDetails(),
  '/control': (context) => const Control(),
  '/selectDevice': (context) =>
      const SelectBondedDevicePage(checkAvailability: false),
  '/settings': (context) => const Settings(),
};
