import 'package:btc_store/routes/app_routes.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Seller App',
      theme: ThemeData(primarySwatch: Colors.blue),
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.login,
      routes: AppRoutes.routes,
    );
  }
}
