import 'package:btc_s/screens/login.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 30),
                Text(
                  'Create Account',
                  style: GoogleFonts.montserrat(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Sign up to get started',
                  style: GoogleFonts.montserrat(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 30),
                buildTextField(
                  label: 'Name',
                  controller: nameController,
                  icon: Icons.person_outline,
                ),
                const SizedBox(height: 20),
                buildTextField(
                  label: 'Email',
                  controller: emailController,
                  icon: Icons.email_outlined,
                ),
                const SizedBox(height: 20),
                buildTextField(
                  label: 'Password',
                  controller: passwordController,
                  icon: Icons.lock_outline,
                  isPassword: true,
                  isVisible: isPasswordVisible,
                  toggleVisibility: () {
                    setState(() => isPasswordVisible = !isPasswordVisible);
                  },
                ),
                const SizedBox(height: 20),
                buildTextField(
                  label: 'Confirm Password',
                  controller: confirmPasswordController,
                  icon: Icons.lock_outline,
                  isPassword: true,
                  isVisible: isConfirmPasswordVisible,
                  toggleVisibility: () {
                    setState(
                      () =>
                          isConfirmPasswordVisible = !isConfirmPasswordVisible,
                    );
                  },
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                        print('Sign Up button tapped');

                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(26),
                      ),
                    ),
                    child: Text(
                      'Sign Up',
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
                  'Or sign up with',
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
                      const TextSpan(text: 'Already have an account? '),
                      TextSpan(
                        text: 'Log in',
                        style: const TextStyle(
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.bold,
                        ),
                        recognizer:
                            TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const LoginScreen(),
                                  ),
                                );
                              },
                      ),
                    ],
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    bool isPassword = false,
    bool isVisible = false,
    VoidCallback? toggleVisibility,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword && !isVisible,
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
                    isVisible ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: toggleVisibility,
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
