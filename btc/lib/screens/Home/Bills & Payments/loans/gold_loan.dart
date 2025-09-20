import 'package:flutter/material.dart';

class GoldLoanScreen extends StatelessWidget {
  const GoldLoanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gold Loan')),
      body: const Center(child: Text('Details about Gold Loan')),
    );
  }
}
