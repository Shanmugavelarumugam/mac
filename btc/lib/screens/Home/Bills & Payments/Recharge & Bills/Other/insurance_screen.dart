import 'package:flutter/material.dart';

class InsuranceScreen extends StatelessWidget {
  const InsuranceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("LIC / Insurance"),
        backgroundColor: const Color(0xFF009688),
      ),
      body: const Center(child: Text("Insurance Screen")),
    );
  }
}
