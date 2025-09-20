import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:resturant_app/dashboard/dashboard_screen.dart';
import 'package:resturant_app/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive and open authBox
  await Hive.initFlutter();
  await Hive.openBox('authBox');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authBox = Hive.box('authBox');
    final isLoggedIn = authBox.get('isLoggedIn', defaultValue: false);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Restaurant App',

      // ✅ Use routes instead of `home`
      initialRoute: isLoggedIn ? '/dashboard' : '/login',
      routes: {
        '/login': (context) => LoginScreen(),
        '/dashboard': (context) => const DashboardScreen(),
      },
    );
  }
}
