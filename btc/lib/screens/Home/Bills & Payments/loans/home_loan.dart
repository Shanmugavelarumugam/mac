import 'package:flutter/material.dart';

class HomeLoanScreen extends StatelessWidget {
  const HomeLoanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home Loan')),
      body: const Center(child: Text('Details about Home Loan')),
    );
  }
}
