import 'package:flutter/material.dart';

class HealthInsuranceScreen extends StatelessWidget {
  const HealthInsuranceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Health Insurance')),
      body: const Center(child: Text('Health Insurance Details')),
    );
  }
}
