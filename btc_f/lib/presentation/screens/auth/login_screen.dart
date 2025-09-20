import 'package:btc_f/presentation/screens/auth/forgot_password_screen.dart';
import 'package:btc_f/presentation/screens/food/navigation/navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../logic/auth/auth_bloc.dart';
import '../../../logic/auth/auth_event.dart';
import '../../../logic/auth/auth_state.dart';
import '../food/navigation/foods/food_list_screen.dart';
import 'signup_screen.dart'; // Optional, for toggle
import 'package:flutter/gestures.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscurePassword = true; // Add this in your _LoginScreenState

  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void _onLogin() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        LoginRequested(
          emailController.text.trim(),
          passwordController.text.trim(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.orange, Colors.deepOrangeAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
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
              child: BlocConsumer<AuthBloc, AuthState>(
                listener: (context, state) {
                  if (state is AuthSuccess) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const NavigationBarScreen(),
                      ),
                    );
                  } else if (state is AuthFailure) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(state.message)));
                  }
                },
                builder: (context, state) {
                  return Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const Text(
                          'Welcome Back 👋',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Login to continue ordering your favorites',
                          style: TextStyle(color: Colors.grey),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),

                        TextFormField(
                          controller: emailController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey[300],
                            prefixIcon: const Icon(Icons.email_outlined),
                            labelText: 'Email',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          validator:
                              (value) =>
                                  value != null && value.contains('@')
                                      ? null
                                      : 'Enter a valid email',
                        ),
                        const SizedBox(height: 16),

                        TextFormField(
                          controller: passwordController,
                          obscureText: _obscurePassword,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey[300],
                            prefixIcon: const Icon(Icons.lock_outline),
                            labelText: 'Password',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
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
                          ),
                          validator:
                              (value) =>
                                  value != null && value.length >= 6
                                      ? null
                                      : 'Minimum 6 characters required',
                        ),
                        const SizedBox(height: 24),
                        state is AuthLoading
                            ? const CircularProgressIndicator()
                            : SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _onLogin,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.deepOrange,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Text(
                                  'Login',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                        const SizedBox(height: 16),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const ForgotPasswordScreen(),
                              ),
                            );
                          },
                          child: const Text('Forgot Password?'),
                        ),

                        const SizedBox(height: 4),
                        Center(
                          child: RichText(
                            text: TextSpan(
                              text: "Don't have an account? ",
                              style: const TextStyle(color: Colors.black),
                              children: [
                                TextSpan(
                                  text: 'Sign up',
                                  style: const TextStyle(
                                    color: Colors.deepOrange,
                                    decoration: TextDecoration.underline,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  recognizer:
                                      TapGestureRecognizer()
                                        ..onTap = () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder:
                                                  (_) => const SignupScreen(),
                                            ),
                                          );
                                        },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
