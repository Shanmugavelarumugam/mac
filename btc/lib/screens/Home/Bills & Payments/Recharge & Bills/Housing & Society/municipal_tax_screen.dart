import 'package:flutter/material.dart';

class MunicipalTaxScreen extends StatelessWidget {
  const MunicipalTaxScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Municipal Tax"),
        backgroundColor: const Color(0xFF009688),
      ),
      body: const Center(child: Text("Municipal Tax Screen")),
    );
  }
}
