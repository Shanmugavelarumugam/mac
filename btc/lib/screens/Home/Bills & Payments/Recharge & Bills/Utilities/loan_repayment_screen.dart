import 'package:flutter/material.dart';

class LoanRepaymentScreen extends StatelessWidget {
  const LoanRepaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Loan Repayment"),
        backgroundColor: const Color(0xFF009688),
      ),
      body: const Center(child: Text("Loan Repayment Screen")),
    );
  }
}
