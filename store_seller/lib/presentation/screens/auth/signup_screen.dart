import 'package:btc_store/bloc/auth/auth_bloc.dart';
import 'package:btc_store/bloc/auth/auth_event.dart';
import 'package:btc_store/bloc/auth/auth_state.dart';
import 'package:btc_store/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final businessController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    businessController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenWidth < 375;

    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            Navigator.pushReplacementNamed(context, AppRoutes.login);
          } else if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            child: Container(
              height: screenHeight,
              padding: EdgeInsets.symmetric(
                horizontal: isSmallScreen ? 24 : 32,
              ),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFF8FAFC), Color(0xFFF1F5F9)],
                ),
              ),
              child: Column(
                children: [
                  SizedBox(height: screenHeight * 0.05),

                  // Back Button
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios_rounded),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),

                  // Logo and Welcome Section
                  Column(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: const Color(0xFF6A5AE0),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF6A5AE0).withOpacity(0.3),
                              blurRadius: 15,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.store_rounded,
                          size: 40,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      Text(
                        "Create Account",
                        style: GoogleFonts.poppins(
                          fontSize: isSmallScreen ? 24 : 28,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1E293B),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.01),
                      Text(
                        "Set up your seller account",
                        style: GoogleFonts.poppins(
                          fontSize: isSmallScreen ? 14 : 16,
                          color: const Color(0xFF64748B),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),

                  SizedBox(height: screenHeight * 0.03),

                  // Signup Form
                  Expanded(
                    child: Form(
                      key: _formKey,
                      child: ListView(
                        shrinkWrap: true,
                        physics: const ClampingScrollPhysics(),
                        children: [
                          // Name Field
                          _buildTextField(
                            controller: nameController,
                            label: "Full Name",
                            icon: Iconsax.user,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your name';
                              }
                              if (value.length < 2) {
                                return 'Name must be at least 2 characters';
                              }
                              return null;
                            },
                          ),

                          SizedBox(height: isSmallScreen ? 12 : 16),

                          // Email Field
                          _buildTextField(
                            controller: emailController,
                            label: "Email Address",
                            icon: Iconsax.sms,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }
                              if (!value.contains('@')) {
                                return 'Please enter a valid email';
                              }
                              return null;
                            },
                          ),

                          SizedBox(height: isSmallScreen ? 12 : 16),

                          // Phone Field
                          _buildTextField(
                            controller: phoneController,
                            label: "Phone Number",
                            icon: Iconsax.call,
                            keyboardType: TextInputType.phone,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your phone number';
                              }
                              if (value.length < 10) {
                                return 'Please enter a valid phone number';
                              }
                              return null;
                            },
                          ),

                          SizedBox(height: isSmallScreen ? 12 : 16),

                          // Password Field
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 10,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: TextFormField(
                              controller: passwordController,
                              obscureText: _obscurePassword,
                              decoration: InputDecoration(
                                labelText: "Password",
                                labelStyle: GoogleFonts.poppins(
                                  color: const Color(0xFF64748B),
                                ),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 18,
                                ),
                                prefixIcon: const Icon(
                                  Iconsax.lock,
                                  color: Color(0xFF94A3B8),
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword
                                        ? Iconsax.eye
                                        : Iconsax.eye_slash,
                                    color: const Color(0xFF94A3B8),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your password';
                                }
                                if (value.length < 6) {
                                  return 'Password must be at least 6 characters';
                                }
                                return null;
                              },
                            ),
                          ),

                          SizedBox(height: isSmallScreen ? 12 : 16),

                          // Business Name Field
                          _buildTextField(
                            controller: businessController,
                            label: "Business Name",
                            icon: Iconsax.building,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your business name';
                              }
                              if (value.length < 2) {
                                return 'Business name must be at least 2 characters';
                              }
                              return null;
                            },
                          ),

                          SizedBox(height: isSmallScreen ? 20 : 24),

                          // Sign Up Button
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              onPressed: state is AuthLoading
                                  ? null
                                  : () {
                                      if (_formKey.currentState!.validate()) {
                                        context.read<AuthBloc>().add(
                                          SignupRequested(
                                            nameController.text.trim(),
                                            emailController.text.trim(),
                                            phoneController.text.trim(),
                                            passwordController.text.trim(),
                                            businessController.text.trim(),
                                          ),
                                        );
                                      }
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF6A5AE0),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 0,
                                shadowColor: Colors.transparent,
                              ),
                              child: state is AuthLoading
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                              Colors.white,
                                            ),
                                      ),
                                    )
                                  : Text(
                                      "Create Account",
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                            ),
                          ),

                          SizedBox(height: screenHeight * 0.02),

                          // Login Link
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Already have an account? ",
                                style: GoogleFonts.poppins(
                                  color: const Color(0xFF64748B),
                                ),
                              ),
                              GestureDetector(
                                onTap: () => Navigator.pushReplacementNamed(
                                  context,
                                  AppRoutes.login,
                                ),
                                child: Text(
                                  "Sign in",
                                  style: GoogleFonts.poppins(
                                    color: const Color(0xFF6A5AE0),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: screenHeight * 0.03),

                          // Footer Text
                          Text(
                            "By creating an account, you agree to our Terms of Service\nand Privacy Policy",
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: const Color(0xFF94A3B8),
                            ),
                            textAlign: TextAlign.center,
                          ),

                          SizedBox(height: screenHeight * 0.02),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    required String? Function(String?) validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.poppins(color: const Color(0xFF64748B)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 18,
          ),
          prefixIcon: Icon(icon, color: const Color(0xFF94A3B8)),
        ),
        validator: validator,
      ),
    );
  }
}
