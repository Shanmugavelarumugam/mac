import 'package:flutter/material.dart';
import 'package:mail/config/theme.dart';
import 'package:mail/presentation/widgets/drawer_widget.dart';

class AllMailScreen extends StatelessWidget {
  const AllMailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(title: const Text("All Mail")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.mail_outline_rounded,
              size: 64,
              color: AppColors.secondary.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              "All Mail",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "All your emails in one place",
              style: TextStyle(color: AppColors.secondary, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
