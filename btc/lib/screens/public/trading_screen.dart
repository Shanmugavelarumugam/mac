import 'package:flutter/material.dart';

class TradingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Trading")),
      body: Center(child: Text("Manage your trading activities here.")),
    );
  }
}
