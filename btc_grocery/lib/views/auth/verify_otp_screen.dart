import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../controllers/auth_controller.dart';

class VerifyOtpScreen extends StatefulWidget {
  final String email;

  const VerifyOtpScreen({super.key, required this.email});

  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _otpController = TextEditingController();
  final _authController = Get.find<AuthController>();

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  void _submitOtp() {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate()) {
      final otp = _otpController.text.trim();
      _authController.verifyOtp(widget.email, otp);
    }
  }

  String? _validateOtp(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'OTP is required';
    } else if (value.trim().length != 6) {
      return 'Enter a 6-digit OTP';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('OTP Verification', style: GoogleFonts.poppins()),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      body: Obx(() {
        if (_authController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                Icon(Icons.verified_user, size: 80, color: Colors.deepPurple),
                const SizedBox(height: 20),
                Text(
                  'Enter OTP',
                  style: GoogleFonts.poppins(
                    fontSize: 26,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  'A 6-digit OTP has been sent to:',
                  style: GoogleFonts.poppins(fontSize: 14),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  widget.email,
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),

                // OTP Field
                TextFormField(
                  controller: _otpController,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  textInputAction: TextInputAction.done,
                  validator: _validateOtp,
                  decoration: InputDecoration(
                    labelText: 'Enter OTP',
                    labelStyle: GoogleFonts.poppins(),
                    prefixIcon: const Icon(Icons.lock_outline),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    counterText: '',
                  ),
                ),
                const SizedBox(height: 30),

                ElevatedButton(
                  onPressed: _submitOtp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Verify OTP',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),

                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    _authController.resendOtp(widget.email);
                    Get.snackbar(
                      'Success',
                      'OTP resent to your email!',
                      backgroundColor: Colors.green.shade100,
                      colorText: Colors.black,
                      snackPosition: SnackPosition.BOTTOM,
                      margin: const EdgeInsets.all(16),
                    );
                  },
                  child: Text(
                    'Didn’t receive OTP? Resend',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.deepPurple,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
