import 'dart:convert';
import 'package:btc_s/screens/login.dart';
import 'package:btc_s/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class ResetPasswordScreen extends StatelessWidget {
  final String email;
  final TextEditingController passwordController = TextEditingController();

  ResetPasswordScreen({super.key, required this.email});

  Future<void> resetPassword(BuildContext context) async {
    final newPassword = passwordController.text.trim();

    if (newPassword.isEmpty) {
      showMessage(context, 'Please enter a new password');
      return;
    }

    final String apiUrl = '${AppConstants.baseUrl}/api/auth/reset-password';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'newPassword': newPassword}),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        showMessage(
          context,
          responseData['message'] ?? 'Password Reset Successful',
        );
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) =>  LoginScreen()),
          (route) => false,
        );
      } else {
        showMessage(context, responseData['message'] ?? 'Reset Failed');
      }
    } catch (e) {
      showMessage(context, 'Error: ${e.toString()}');
    }
  }

  void showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reset Password', style: GoogleFonts.montserrat()),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const SizedBox(height: 40),
            Text(
              'Enter new password for $email',
              style: GoogleFonts.montserrat(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            TextField(
              controller: passwordController,
              obscureText: true,
              style: GoogleFonts.montserrat(),
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.lock_outline),
                labelText: 'New Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () => resetPassword(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(26),
                  ),
                ),
                child: Text(
                  'Reset Password',
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
