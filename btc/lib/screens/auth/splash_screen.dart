import 'package:btc/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'sign_screen.dart'; // your login/register screen

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _checkLogin();
  }

  Future<void> _checkLogin() async {
    await Future.delayed(
      const Duration(seconds: 2),
    ); // show splash for a moment
    final token = await _storage.read(key: 'authToken');

    if (!mounted) return;

    Widget targetScreen =
        (token != null && token.isNotEmpty)
            ?  HomeScreen()
            : const SignScreen();

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => targetScreen,
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 700),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo/btc.png', // your asset logo
              width: 150,
              height: 150,
            ),
            const SizedBox(height: 20),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
