import 'package:flutter/material.dart';

class DthScreen extends StatelessWidget {
  const DthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("DTH"),
        backgroundColor: const Color(0xFF009688),
      ),
      body: const Center(child: Text("DTH Screen")),
    );
  }
}
