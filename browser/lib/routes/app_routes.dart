import 'package:browser/presentation/screens/home_screen.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static const String home = '/';

  static final routes = <String, WidgetBuilder>{
    home: (context) => const HomeScreen(),
  };
}
