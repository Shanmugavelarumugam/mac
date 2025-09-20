import 'package:flutter/material.dart';

class PensionScreen extends StatelessWidget {
  const PensionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pension')),
      body: const Center(child: Text('Pension Details')),
    );
  }
}
