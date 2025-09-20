import 'package:btc_s/screens/home_screen.dart';
import 'package:btc_s/screens/login.dart';
import 'package:btc_s/utils/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // ✅ Ensures platform channels are ready

  // Check if token exists
  String? token = await UserPreferences.getToken();

  runApp(TradeOutfitApp(isLoggedIn: token != null));
}

class TradeOutfitApp extends StatelessWidget {
  final bool isLoggedIn;

  TradeOutfitApp({required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trade Outfit',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(textTheme: GoogleFonts.montserratTextTheme()),
      home: HomeScreen(),
    );
  }
}

//      home: isLoggedIn ? HomeScreen() : LoginScreen(),
