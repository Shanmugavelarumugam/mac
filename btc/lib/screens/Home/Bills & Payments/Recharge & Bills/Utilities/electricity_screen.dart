import 'package:flutter/material.dart';

class ElectricityScreen extends StatelessWidget {
  const ElectricityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Electricity"),
        backgroundColor: const Color(0xFF009688),
      ),
      body: const Center(child: Text("Electricity Screen")),
    );
  }
}
