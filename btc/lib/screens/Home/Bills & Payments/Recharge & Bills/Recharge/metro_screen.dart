import 'package:flutter/material.dart';

class MetroScreen extends StatelessWidget {
  const MetroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Metro"),
        backgroundColor: const Color(0xFF009688),
      ),
      body: const Center(child: Text("Metro Screen")),
    );
  }
}
