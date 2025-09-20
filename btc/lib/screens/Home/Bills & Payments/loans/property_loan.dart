import 'package:flutter/material.dart';

class PropertyLoanScreen extends StatelessWidget {
  const PropertyLoanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Property Loan')),
      body: const Center(child: Text('Details about Property Loan')),
    );
  }
}
