import 'package:btc/screens/Home/Bills%20&%20Payments/recharge_bills_screen.dart';
import 'package:flutter/material.dart';

class MobileRechargeScreen extends StatelessWidget {
  const MobileRechargeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mobile Recharge"),
        backgroundColor: RechargeBillsScreen.customColor,
      ),
      body: const Center(child: Text("Mobile Recharge Screen")),
    );
  }
}
