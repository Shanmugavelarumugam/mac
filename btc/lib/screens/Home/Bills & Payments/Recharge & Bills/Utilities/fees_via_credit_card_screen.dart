import 'package:flutter/material.dart';

class FeesViaCreditCardScreen extends StatelessWidget {
  const FeesViaCreditCardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Fees via Credit Card"),
        backgroundColor: const Color(0xFF009688),
      ),
      body: const Center(child: Text("Fees via Credit Card Screen")),
    );
  }
}
