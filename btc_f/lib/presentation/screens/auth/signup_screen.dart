import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../logic/auth/auth_bloc.dart';
import '../../../logic/auth/auth_event.dart';
import '../../../logic/auth/auth_state.dart';
import '../food/navigation/foods/food_list_screen.dart';
import 'login_screen.dart';
import 'package:flutter/gestures.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool _obscurePassword = true;
  final confirmPasswordController = TextEditingController();
  bool _obscureConfirmPassword = true;

  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void _onSignup() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        SignupRequested(
          nameController.text.trim(),
          emailController.text.trim(),
          passwordController.text.trim(),
        ),
      );
    }
  }

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
                      MaterialPageRoute(builder: (_) => FoodListScreen()),
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
                          'Create Account 🎉',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Sign up to order delicious food near you',
                          style: TextStyle(color: Colors.grey),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        TextFormField(
                          controller: nameController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey[200],
                            prefixIcon: const Icon(Icons.person),
                            labelText: 'Full Name',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          validator:
                              (value) =>
                                  value != null && value.length >= 3
                                      ? null
                                      : 'Enter your name',
                        ),
                        const SizedBox(height: 16),

                        TextFormField(
                          controller: emailController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey[200],
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
                            fillColor: Colors.grey[200],
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
                                      : 'Minimum 6 characters',
                        ),
                        const SizedBox(height: 16),

                        TextFormField(
                          controller: confirmPasswordController,
                          obscureText: _obscureConfirmPassword,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey[200],
                            prefixIcon: const Icon(Icons.lock),
                            labelText: 'Confirm Password',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
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
                          ),
                          validator:
                              (value) =>
                                  value == passwordController.text
                                      ? null
                                      : 'Passwords do not match',
                        ),

                        const SizedBox(height: 24),
                        state is AuthLoading
                            ? const CircularProgressIndicator()
                            : SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _onSignup,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.deepOrange,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Text('Sign Up'),
                              ),
                            ),
                        const SizedBox(height: 16),
                        Center(
                          child: RichText(
                            text: TextSpan(
                              text: "Already have an account? ",
                              style: const TextStyle(color: Colors.black),
                              children: [
                                TextSpan(
                                  text: 'Login',
                                  style: const TextStyle(
                                    color: Colors.deepOrange,
                                    decoration: TextDecoration.underline,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  recognizer:
                                      TapGestureRecognizer()
                                        ..onTap = () {
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder:
                                                  (_) => const LoginScreen(),
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
