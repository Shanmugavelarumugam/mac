import 'dart:convert';
import 'package:btc_s/screens/verify_otp_screen.dart';
import 'package:btc_s/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController emailController = TextEditingController();
  bool isLoading = false;

  Future<void> sendPasswordReset(BuildContext context) async {
    final String email = emailController.text.trim();

    if (email.isEmpty) {
      showMessage(context, 'Please enter your email');
      return;
    }

    setState(() => isLoading = true);

    final String apiUrl = '${AppConstants.baseUrl}/api/auth/forgot-password';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        showMessage(
          context,
          responseData['message'] ?? 'OTP sent to your email',
        );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => VerifyOtpScreen(email: email)),
        );
      } else {
        showMessage(context, responseData['message'] ?? 'Failed to send OTP');
      }
    } catch (e) {
      showMessage(context, 'Error: ${e.toString()}');
    } finally {
      setState(() => isLoading = false);
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Text(
              'Forgot Your Password?',
              style: GoogleFonts.montserrat(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Enter your email address and we will send you an OTP to reset your password.',
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 30),
            TextField(
              controller: emailController,
              style: GoogleFonts.montserrat(),
              decoration: InputDecoration(
                prefixIcon: const Icon(
                  Icons.email_outlined,
                  color: Colors.black,
                ),
                labelText: 'Enter the email',
                labelStyle: GoogleFonts.montserrat(),
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
                onPressed: isLoading ? null : () => sendPasswordReset(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(26),
                  ),
                ),
                child:
                    isLoading
                        ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                        : Text(
                          'Send OTP',
                          style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 16,
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
