import 'package:xc/general.dart';
import 'package:xc/screens/home.dart';
import 'package:xc/screens/settings.dart';

var routes = {
  '/': (context) => const HomeScreen(),
  '/general': (context) => GeneralPage(),
  '/settings': (context) => Settings(),
};
