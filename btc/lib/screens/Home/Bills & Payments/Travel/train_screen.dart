import 'package:flutter/material.dart';

class TrainScreen extends StatelessWidget {
  const TrainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Train')),
      body: const Center(child: Text('Train Booking Details')),
    );
  }
}
