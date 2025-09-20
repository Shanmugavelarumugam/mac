import 'package:flutter/material.dart';

class AirportCabsScreen extends StatelessWidget {
  const AirportCabsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Airport Cabs')),
      body: const Center(child: Text('Book Airport Cabs')),
    );
  }
}
