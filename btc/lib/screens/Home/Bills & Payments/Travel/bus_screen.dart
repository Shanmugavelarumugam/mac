import 'package:flutter/material.dart';

class BusScreen extends StatelessWidget {
  const BusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bus')),
      body: const Center(child: Text('Bus Booking Details')),
    );
  }
}
