import 'package:flutter/material.dart';

class PrepaidMeterScreen extends StatelessWidget {
  const PrepaidMeterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Prepaid Meter"),
        backgroundColor: const Color(0xFF009688),
      ),
      body: const Center(child: Text("Prepaid Meter Screen")),
    );
  }
}
