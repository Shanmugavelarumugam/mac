import 'package:flutter/material.dart';

class BikeLoanScreen extends StatelessWidget {
  const BikeLoanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bike Loan')),
      body: const Center(child: Text('Details about Bike Loan')),
    );
  }
}
