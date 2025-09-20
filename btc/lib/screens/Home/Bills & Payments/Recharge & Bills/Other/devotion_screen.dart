import 'package:flutter/material.dart';

class DevotionScreen extends StatelessWidget {
  const DevotionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Devotion"),
        backgroundColor: const Color(0xFF009688),
      ),
      body: const Center(child: Text("Devotion Screen")),
    );
  }
}
