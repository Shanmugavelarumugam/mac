import 'package:flutter/material.dart';

class FastagRechargeScreen extends StatelessWidget {
  const FastagRechargeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("FASTag Recharge"),
        backgroundColor: const Color(0xFF009688),
      ),
      body: const Center(child: Text("FASTag Recharge Screen")),
    );
  }
}
