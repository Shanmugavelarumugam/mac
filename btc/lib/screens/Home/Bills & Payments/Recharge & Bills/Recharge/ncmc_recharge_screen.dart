import 'package:flutter/material.dart';

class NcmcRechargeScreen extends StatelessWidget {
  const NcmcRechargeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("NCMC Recharge"),
        backgroundColor: const Color(0xFF009688),
      ),
      body: const Center(child: Text("NCMC Recharge Screen")),
    );
  }
}
