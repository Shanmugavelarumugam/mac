import 'dart:convert';
import 'package:btc_s/screens/forgot_password.dart';
import 'package:btc_s/screens/home_screen.dart';
import 'package:btc_s/screens/sign_up.dart';
import 'package:btc_s/utils/constants.dart';
import 'package:btc_s/utils/shared_preferences.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool isPasswordVisible = false;
  late TapGestureRecognizer _signUpRecognizer;

  final String apiUrl = AppConstants.loginApi;

  @override
  void initState() {
    super.initState();
    _signUpRecognizer =
        TapGestureRecognizer()
          ..onTap = () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => SignUpScreen()),
            );
          };
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    _signUpRecognizer.dispose();
    super.dispose();
  }

  Future<void> loginUser(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    final String email = emailController.text.trim();
    final String password = passwordController.text.trim();

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.body.isEmpty) {
        showMessage(context, 'Empty response from server');
        return;
      }

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final String token = responseData['token'];
        final String name = responseData['user']['name'];
        final String userEmail = responseData['user']['email'];
        final String userId = responseData['user']['id'].toString();

        await UserPreferences.saveToken(token);
        await UserPreferences.saveUserName(name);
        await UserPreferences.saveUserEmail(userEmail);
        await UserPreferences.saveUserId(userId);

        showMessage(context, 'Login successful');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      } else {
        showMessage(context, responseData['message'] ?? 'Login failed');
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

  bool isValidEmail(String email) {
    return RegExp(r'^[\w\-\.]+@([\w\-]+\.)+[\w]{2,4}\$').hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 30),
                  Text(
                    'Welcome Back',
                    style: GoogleFonts.montserrat(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Login to your account',
                    style: GoogleFonts.montserrat(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 30),
                  buildTextField(
                    icon: Icons.email_outlined,
                    label: 'Email',
                    controller: emailController,
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Enter email';
                      if (!isValidEmail(value)) return 'Enter a valid email';
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  buildTextField(
                    icon: Icons.lock_outline,
                    label: 'Password',
                    controller: passwordController,
                    isPassword: true,
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return 'Enter password';
                      if (value.length < 6) return 'Minimum 6 characters';
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ForgotPasswordScreen(),
                          ),
                        );
                      },
                      child: Text(
                        'Forgot Password?',
                        style: GoogleFonts.montserrat(
                          fontSize: 13,
                          color: Colors.grey[800],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : () => loginUser(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(26),
                        ),
                      ),
                      child:
                          isLoading
                              ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                              : Text(
                                'Log in',
                                style: GoogleFonts.montserrat(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Or sign in with',
                    style: GoogleFonts.montserrat(
                      color: Colors.grey[600],
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      socialIcon('assets/google.png', () {}),
                      const SizedBox(width: 20),
                      socialIcon('assets/apple.png', () {}),
                      const SizedBox(width: 20),
                      socialIcon('assets/fb.png', () {}),
                    ],
                  ),
                  const SizedBox(height: 30),
                  RichText(
                    text: TextSpan(
                      style: GoogleFonts.montserrat(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                      children: [
                        const TextSpan(text: 'Don\'t have an account? '),
                        TextSpan(
                          text: 'Sign Up',
                          style: const TextStyle(
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.bold,
                          ),
                          recognizer: _signUpRecognizer,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField({
    required IconData icon,
    required String label,
    required TextEditingController controller,
    bool isPassword = false,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword ? !isPasswordVisible : false,
      validator: validator,
      style: GoogleFonts.montserrat(),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.black),
        labelText: label,
        labelStyle: GoogleFonts.montserrat(),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        suffixIcon:
            isPassword
                ? IconButton(
                  icon: Icon(
                    isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() => isPasswordVisible = !isPasswordVisible);
                  },
                )
                : null,
      ),
    );
  }

  Widget socialIcon(String assetPath, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 70,
        height: 70,
        padding: const EdgeInsets.all(10),
        child: Image.asset(assetPath, fit: BoxFit.contain),
      ),
    );
  }
}
