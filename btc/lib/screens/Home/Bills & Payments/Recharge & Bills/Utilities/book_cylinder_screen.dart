import 'package:flutter/material.dart';

class BookCylinderScreen extends StatelessWidget {
  const BookCylinderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Book Cylinder"),
        backgroundColor: const Color(0xFF009688),
      ),
      body: const Center(child: Text("Book Cylinder Screen")),
    );
  }
}
