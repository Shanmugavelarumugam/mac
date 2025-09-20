import 'package:flutter/material.dart';

class NpsContributionScreen extends StatelessWidget {
  const NpsContributionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("NPS Contribution"),
        backgroundColor: const Color(0xFF009688),
      ),
      body: const Center(child: Text("NPS Contribution Screen")),
    );
  }
}
