import 'package:btc_c/screens/home_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(TradeOutfitApp());
}

class TradeOutfitApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trade Outfit',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'Roboto'),
      home: HomeScreen(),
    );
  }
}
