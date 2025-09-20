import 'package:flutter/material.dart';

class TravelInsuranceScreen extends StatelessWidget {
  const TravelInsuranceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Travel Insurance')),
      body: const Center(child: Text('Get travel insurance details here')),
    );
  }
}
