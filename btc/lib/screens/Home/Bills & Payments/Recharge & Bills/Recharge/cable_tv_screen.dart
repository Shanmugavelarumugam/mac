import 'package:flutter/material.dart';

class CableTvScreen extends StatelessWidget {
  const CableTvScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cable TV"),
        backgroundColor: const Color(0xFF009688),
      ),
      body: const Center(child: Text("Cable TV Screen")),
    );
  }
}
