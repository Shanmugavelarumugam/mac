import 'package:flutter/material.dart';

class BikeInsuranceScreen extends StatelessWidget {
  const BikeInsuranceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bike Insurance')),
      body: const Center(child: Text('Bike Insurance Details')),
    );
  }
}
