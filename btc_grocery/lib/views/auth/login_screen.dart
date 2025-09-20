import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../controllers/auth_controller.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _authController = Get.put(AuthController());

  final RxBool _obscurePassword = true.obs;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _submit() {
    // Dismiss the keyboard
    FocusScope.of(context).unfocus();

    if (_formKey.currentState!.validate()) {
      final email = _email.text.trim();
      final password = _password.text.trim();
      _authController.login(email, password);
    }
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Enter a valid email';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Password is required';
    }
    if (value.trim().length < 8) {
      return 'Password must be at least 8 characters';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(() {
        if (_authController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction, // ✅ Added
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,

                children: [
                  const Icon(
                    Icons.lock_outline,
                    size: 80,
                    color: Colors.deepPurple,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Welcome Back!',
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),

                  // Email Field
                  TextFormField(
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    autofocus: true,
                    validator: _validateEmail,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      prefixIcon: const Icon(Icons.email_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Password Field
                  Obx(
                    () => TextFormField(
                      controller: _password,
                      obscureText: _obscurePassword.value,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _submit(),
                      validator: _validatePassword,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword.value
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          tooltip:
                              _obscurePassword.value
                                  ? 'Show password'
                                  : 'Hide password',
                          onPressed:
                              () =>
                                  _obscurePassword.value =
                                      !_obscurePassword.value,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade100,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Forgot Password
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => Get.toNamed('/forgot-password'),
                      child: Text(
                        'Forgot Password?',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.deepPurple,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Login Button
                  Obx(
                    () => ElevatedButton(
                      onPressed:
                          _authController.isLoading.value ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child:
                          _authController.isLoading.value
                              ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                              : Text(
                                'Login',
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                    ),
                  ),
                  const SizedBox(height: 20),

                  // Signup Redirect
                  Center(
                    child: RichText(
                      text: TextSpan(
                        style: GoogleFonts.poppins(
                          color: Colors.black87,
                          fontSize: 14,
                        ),
                        children: [
                          const TextSpan(
                            text: 'Don’t have an account? ',
                          ),
                          TextSpan(
                            text: 'Sign up',
                            style: const TextStyle(
                              color: Colors.deepPurple,

                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.bold,
                            ),
                            recognizer:
                                TapGestureRecognizer()
                                  ..onTap = () => Get.toNamed('/signup'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
