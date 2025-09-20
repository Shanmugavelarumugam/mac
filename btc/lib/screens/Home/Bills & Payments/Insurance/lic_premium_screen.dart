import 'package:flutter/material.dart';

class LicPremiumScreen extends StatelessWidget {
  const LicPremiumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('LIC / Premium Payment')),
      body: const Center(child: Text('LIC or Premium Payment Details')),
    );
  }
}
