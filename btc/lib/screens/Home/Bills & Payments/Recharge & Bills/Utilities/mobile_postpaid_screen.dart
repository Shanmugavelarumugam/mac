import 'package:flutter/material.dart';

class MobilePostpaidScreen extends StatelessWidget {
  const MobilePostpaidScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mobile Postpaid"),
        backgroundColor: const Color(0xFF009688),
      ),
      body: const Center(child: Text("Mobile Postpaid Screen")),
    );
  }
}
