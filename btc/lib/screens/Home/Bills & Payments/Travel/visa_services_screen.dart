import 'package:flutter/material.dart';

class VisaServicesScreen extends StatelessWidget {
  const VisaServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Visa Services')),
      body: const Center(child: Text('Apply or track your Visa')),
    );
  }
}
