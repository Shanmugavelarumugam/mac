import 'package:flutter/material.dart';

class ClubsAssociationsScreen extends StatelessWidget {
  const ClubsAssociationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Clubs & Associations"),
        backgroundColor: const Color(0xFF009688),
      ),
      body: const Center(child: Text("Clubs & Associations Screen")),
    );
  }
}
