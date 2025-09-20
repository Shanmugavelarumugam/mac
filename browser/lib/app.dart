import 'package:browser/routes/app_routes.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Browser',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: AppRoutes.home,
      routes: AppRoutes.routes,
    );
  }
}
