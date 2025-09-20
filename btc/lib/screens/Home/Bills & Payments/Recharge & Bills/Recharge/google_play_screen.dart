import 'package:flutter/material.dart';

class GooglePlayScreen extends StatelessWidget {
  const GooglePlayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Google Play"),
        backgroundColor: const Color(0xFF009688),
      ),
      body: const Center(child: Text("Google Play Screen")),
    );
  }
}
