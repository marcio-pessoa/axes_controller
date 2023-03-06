import 'package:flutter/material.dart';
import 'package:xc/themes/dark.dart';
import 'package:xc/themes/light.dart';

import './MainPage.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "xC",
      debugShowCheckedModeBanner: false,
      theme: lightTheme(),
      darkTheme: darkTheme(),
      home: MainPage(),
    );
  }
}
