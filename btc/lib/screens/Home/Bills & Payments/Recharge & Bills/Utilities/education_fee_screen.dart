import 'package:flutter/material.dart';

class EducationFeeScreen extends StatelessWidget {
  const EducationFeeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Education Fee"),
        backgroundColor: const Color(0xFF009688),
      ),
      body: const Center(child: Text("Education Fee Screen")),
    );
  }
}
