import 'package:btc_f/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'login_screen.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email;

  const ResetPasswordScreen({super.key, required this.email});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final Dio dio = Dio();
  bool isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  Future<void> resetPassword() async {
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password must be at least 6 characters")),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Passwords do not match")));
      return;
    }

    setState(() => isLoading = true);

    try {
     final response = await dio.post(
        resetPasswordApi,
        data: {'email': widget.email, 'newPassword': password},
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            response.data['message'] ?? 'Password reset successful',
          ),
        ),
      );

      await Future.delayed(const Duration(milliseconds: 300));
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Failed to reset password")));
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // Gradient Background
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.orange, Colors.deepOrangeAccent],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          // Back Button
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 8.0),
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.white,
                  size: 24,
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),

          // Centered Card
          Center(
            child: SingleChildScrollView(
              child: Container(
                width: size.width * 0.85,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(2, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.lock_reset,
                      size: 60,
                      color: Colors.deepOrange,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Enter your new password 🔐",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),

                    // New Password
                    TextField(
                      controller: passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[200],
                        labelText: "New Password",
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Confirm Password
                    TextField(
                      controller: confirmPasswordController,
                      obscureText: _obscureConfirmPassword,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[200],
                        labelText: "Confirm Password",
                        prefixIcon: const Icon(Icons.lock_reset),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirmPassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureConfirmPassword =
                                  !_obscureConfirmPassword;
                            });
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : resetPassword,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepOrange,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child:
                            isLoading
                                ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                                : const Text(
                                  "Reset Password",
                                  style: TextStyle(fontSize: 16),
                                ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
