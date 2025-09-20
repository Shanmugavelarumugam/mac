import 'package:flutter/material.dart';

class ApartmentScreen extends StatelessWidget {
  const ApartmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Apartment"),
        backgroundColor: const Color(0xFF009688),
      ),
      body: const Center(child: Text("Apartment Screen")),
    );
  }
}
