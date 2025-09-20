import 'package:cloud/screens/account_screen.dart';
import 'package:cloud/screens/starred_screen.dart';
import 'package:cloud/screens/upload_screen.dart';
import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(MyDriveApp());
}

class MyDriveApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyDrive',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: Color(0xFFF2F4F8),
        appBarTheme: AppBarTheme(backgroundColor: Colors.indigo, elevation: 0),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: Color(0xFF121212),
        appBarTheme: AppBarTheme(backgroundColor: Colors.black, elevation: 0),
      ),
      themeMode: ThemeMode.system,
      home: AccountScreen(),
    );
  }
}
