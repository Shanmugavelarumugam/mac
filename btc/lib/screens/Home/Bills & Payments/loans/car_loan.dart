import 'package:flutter/material.dart';

class CarLoanScreen extends StatelessWidget {
  const CarLoanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Car Loan')),
      body: const Center(child: Text('Details about Car Loan')),
    );
  }
}
