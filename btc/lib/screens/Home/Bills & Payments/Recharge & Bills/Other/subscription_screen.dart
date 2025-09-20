import 'package:flutter/material.dart';

class SubscriptionScreen extends StatelessWidget {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Subscription"),
        backgroundColor: const Color(0xFF009688),
      ),
      body: const Center(child: Text("Subscription Screen")),
    );
  }
}
