import 'package:flutter/material.dart';

class CarInsuranceScreen extends StatelessWidget {
  const CarInsuranceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Car Insurance')),
      body: const Center(child: Text('Car Insurance Details')),
    );
  }
}
