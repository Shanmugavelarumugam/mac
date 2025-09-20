import 'package:flutter/material.dart';

class BroadbandLandlineScreen extends StatelessWidget {
  const BroadbandLandlineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Broadband/Landline"),
        backgroundColor: const Color(0xFF009688),
      ),
      body: const Center(child: Text("Broadband/Landline Screen")),
    );
  }
}
