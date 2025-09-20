import 'package:flutter/material.dart';

class DengueMalariaScreen extends StatelessWidget {
  const DengueMalariaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dengue & Malaria Insurance')),
      body: const Center(child: Text('Coverage for Dengue & Malaria')),
    );
  }
}
