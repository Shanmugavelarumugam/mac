import 'package:flutter/material.dart';

class PipedGasScreen extends StatelessWidget {
  const PipedGasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Piped Gas"),
        backgroundColor: const Color(0xFF009688),
      ),
      body: const Center(child: Text("Piped Gas Screen")),
    );
  }
}
