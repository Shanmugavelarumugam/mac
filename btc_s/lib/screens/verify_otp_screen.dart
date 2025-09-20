import 'dart:convert';
import 'package:btc_s/screens/reset_password_screen.dart';
import 'package:btc_s/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class VerifyOtpScreen extends StatefulWidget {
  final String email;
  const VerifyOtpScreen({super.key, required this.email});

  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  final List<TextEditingController> _otpControllers = List.generate(
    6,
    (_) => TextEditingController(),
  );

  final FocusNode _focusNode = FocusNode();

  void showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> verifyOtp(BuildContext context) async {
    final otp = _otpControllers.map((c) => c.text).join();

    if (otp.length < 6) {
      showMessage(context, 'Please enter all 6 digits');
      return;
    }

    final String apiUrl = '${AppConstants.baseUrl}/api/auth/verify-otp';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': widget.email, 'otp': otp}),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        showMessage(context, responseData['message'] ?? 'OTP Verified');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => ResetPasswordScreen(email: widget.email),
          ),
        );
      } else {
        showMessage(context, responseData['message'] ?? 'Invalid OTP');
      }
    } catch (e) {
      showMessage(context, 'Error: ${e.toString()}');
    }
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
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Text(
              'Verification Code',
              style: GoogleFonts.montserrat(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              'Please enter the verification code we sent to your ${widget.email}',
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(
                color: Colors.grey[700],
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(6, (index) {
                return SizedBox(
                  width: 45,
                  child: TextField(
                    controller: _otpControllers[index],
                    focusNode: index == 0 ? _focusNode : null,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    maxLength: 1,
                    style: GoogleFonts.montserrat(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                    decoration: InputDecoration(
                      counterText: '',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onChanged: (value) {
                      if (value.isNotEmpty && index < 5) {
                        FocusScope.of(context).nextFocus();
                      } else if (value.isEmpty && index > 0) {
                        FocusScope.of(context).previousFocus();
                      }
                    },
                  ),
                );
              }),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () => verifyOtp(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(26),
                  ),
                ),
                child: Text(
                  'Verify OTP',
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
