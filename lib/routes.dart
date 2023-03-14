import 'package:xc/SelectBondedDevicePage.dart';
import 'package:xc/screens/control.dart';
import 'package:xc/screens/home.dart';
import 'package:xc/screens/settings.dart';

var routes = {
  '/': (context) => const HomeScreen(),
  '/control': (context) => const Control(),
  '/selectDevice': (context) =>
      const SelectBondedDevicePage(checkAvailability: false),
  '/settings': (context) => const Settings(),
};
