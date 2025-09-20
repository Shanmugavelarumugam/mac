import 'package:flutter/material.dart';

class RentViaCreditCardScreen extends StatelessWidget {
  const RentViaCreditCardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Rent via Credit Card"),
        backgroundColor: const Color(0xFF009688),
      ),
      body: const Center(child: Text("Rent via Credit Card Screen")),
    );
  }
}
