import 'package:flutter/material.dart';

class DonationsScreen extends StatelessWidget {
  const DonationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Donations"),
        backgroundColor: const Color(0xFF009688),
      ),
      body: const Center(child: Text("Donations Screen")),
    );
  }
}
