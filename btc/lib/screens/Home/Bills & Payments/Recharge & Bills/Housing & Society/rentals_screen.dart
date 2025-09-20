import 'package:flutter/material.dart';

class RentalsScreen extends StatelessWidget {
  const RentalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Rentals"),
        backgroundColor: const Color(0xFF009688),
      ),
      body: const Center(child: Text("Rentals Screen")),
    );
  }
}
