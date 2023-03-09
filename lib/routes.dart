import 'package:xc/general.dart';
import 'package:xc/screens/control.dart';
import 'package:xc/screens/home.dart';
import 'package:xc/screens/settings.dart';

var routes = {
  '/': (context) => const HomeScreen(),
  '/control': (context) => Control(),
  '/general': (context) => GeneralSettings(),
  '/settings': (context) => Settings(),
};
