import 'package:flutter/material.dart';

class CreditCardBillScreen extends StatelessWidget {
  const CreditCardBillScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Credit Card Bill"),
        backgroundColor: const Color(0xFF009688),
      ),
      body: const Center(child: Text("Credit Card Bill Screen")),
    );
  }
}
