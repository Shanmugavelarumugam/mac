import 'package:flutter/material.dart';
import 'package:mail/config/theme.dart';
import 'package:mail/routes/app_routes.dart';


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MailBox',
      theme: appTheme,
      home: const MailHome(),
    );
  }
}
