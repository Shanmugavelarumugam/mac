import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:btc_grocery/controllers/auth_controller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final AuthController _authController = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  void _checkLoginStatus() async {
    await Future.delayed(const Duration(seconds: 2));
    await _authController.checkLogin();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
