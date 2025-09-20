import 'package:flutter/material.dart';

class WaterScreen extends StatelessWidget {
  const WaterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Water"),
        backgroundColor: const Color(0xFF009688),
      ),
      body: const Center(child: Text("Water Screen")),
    );
  }
}
