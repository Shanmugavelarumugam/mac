import 'package:flutter/material.dart';

class AppleStoreScreen extends StatelessWidget {
  const AppleStoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Apple Store"),
        backgroundColor: const Color(0xFF009688),
      ),
      body: const Center(child: Text("Apple Store Screen")),
    );
  }
}
