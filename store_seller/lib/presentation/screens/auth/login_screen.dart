import 'package:btc_store/bloc/auth/auth_bloc.dart';
import 'package:btc_store/bloc/auth/auth_event.dart';
import 'package:btc_store/bloc/auth/auth_state.dart';
import 'package:btc_store/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenWidth < 375;

    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) async {
          print("AuthBloc State Changed: $state"); // ✅ Print every state change

          if (state is AuthSuccess) {
            final response = state.response;
            print(
              "Login Success: Token=${response.token}, Seller=${response.seller?.name ?? 'null'}",
            );

            // Save token, user id, AND seller name in SharedPreferences
            final prefs = await SharedPreferences.getInstance();
            if (response.token != null) {
              await prefs.setString('auth_token', response.token!);
              print("Saved auth_token: ${response.token}");
            }
            if (response.seller != null) {
              await prefs.setInt('user_id', response.seller!.id);
              print("Saved user_id: ${response.seller!.id}");

              // ✅ ADD THIS LINE: Store the seller name
              await prefs.setString('seller_name', response.seller!.name);
              print("Saved seller_name: ${response.seller!.name}");
            }

            // Navigate based on access
            if (response.message.contains("doesn't Access")) {
              print("User doesn't have access, navigating to noAccess screen");
              Navigator.pushReplacementNamed(context, AppRoutes.noAccess);
            } else {
              print("User has access, navigating to home screen");
              Navigator.pushReplacementNamed(context, AppRoutes.home);
            }
          } else if (state is AuthFailure) {
            print("Login Failed: ${state.error}");
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
                  SizedBox(height: screenHeight * 0.1),

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
                      SizedBox(height: screenHeight * 0.03),
                      Text(
                        "Welcome Back",
                        style: GoogleFonts.poppins(
                          fontSize: isSmallScreen ? 24 : 28,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1E293B),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.01),
                      Text(
                        "Sign in to your seller account",
                        style: GoogleFonts.poppins(
                          fontSize: isSmallScreen ? 14 : 16,
                          color: const Color(0xFF64748B),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),

                  SizedBox(height: screenHeight * 0.05),

                  // Login Form
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // Email Field
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
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              labelText: "Email Address",
                              labelStyle: GoogleFonts.poppins(
                                color: const Color(0xFF64748B),
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 18,
                              ),
                              prefixIcon: const Icon(
                                Iconsax.sms,
                                color: Color(0xFF94A3B8),
                              ),
                            ),
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
                        ),

                        SizedBox(height: isSmallScreen ? 16 : 20),

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

                        SizedBox(height: isSmallScreen ? 16 : 20),

                        // Login Button
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                           onPressed: state is AuthLoading
                                ? null
                                : () {
                                    if (_formKey.currentState!.validate()) {
                                      final email = emailController.text.trim();
                                      final password = passwordController.text
                                          .trim();
                                      print(
                                        "Login Button Pressed with Email: $email, Password: $password",
                                      );
                                      context.read<AuthBloc>().add(
                                        LoginRequested(email, password),
                                      );
                                    } else {
                                      print("Form validation failed");
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
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                : Text(
                                    "Sign In",
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.03),

                  // Sign Up Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account? ",
                        style: GoogleFonts.poppins(
                          color: const Color(0xFF64748B),
                        ),
                      ),
                      GestureDetector(
                        onTap: () =>
                            Navigator.pushNamed(context, AppRoutes.signup),
                        child: Text(
                          "Sign up",
                          style: GoogleFonts.poppins(
                            color: const Color(0xFF6A5AE0),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: screenHeight * 0.05),

                  // Footer Text
                  Text(
                    "By continuing, you agree to our Terms of Service\nand Privacy Policy",
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: const Color(0xFF94A3B8),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
