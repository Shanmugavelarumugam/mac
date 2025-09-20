import 'package:flutter/material.dart';
import 'presentation/screens/auth/login_screen.dart';
import 'presentation/screens/food/navigation/navigation_bar.dart';

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BTC Food',
      theme: ThemeData(primarySwatch: Colors.orange),
      home: isLoggedIn ? const NavigationBarScreen() : const LoginScreen(),
    );
  }
}
