import 'package:btc/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'sign_screen.dart';

class LoginScreen extends StatefulWidget {
  // Updated callback to receive both token and userId
  final void Function(String token, int userId) onLoginSuccess;

  const LoginScreen({Key? key, required this.onLoginSuccess}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  bool _loading = false;
  late AnimationController _btnAnimationController;

  @override
  void initState() {
    super.initState();
    _btnAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
      lowerBound: 0.0,
      upperBound: 0.1,
    );
  }

  @override
  void dispose() {
    _btnAnimationController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() async {
    setState(() => _loading = true);
    try {
      print('Attempting login with email: ${_emailController.text.trim()}');
      final result = await _authService.loginUser(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      print('Login response: $result');

      final token = result['token'] as String;
      final userId = result['user']['id'] as int; // Extract userId here

      print('Received token: $token');
      print('Received userId: $userId');

      // Pass both token and userId to parent callback
      widget.onLoginSuccess(token, userId);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'] ?? 'Login successful')),
      );
    } catch (e) {
      print('Login failed with error: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Login failed: $e')));
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scale = 1 - _btnAnimationController.value;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF4facfe), Color(0xFF00f2fe)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
        child: Center(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Card(
                elevation: 12,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                color: Colors.white.withOpacity(0.95),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 36,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.lock_outline,
                        size: 72,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Welcome Back!',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.7,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Login to your account',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: Colors.grey[700],
                          letterSpacing: 0.4,
                        ),
                      ),
                      const SizedBox(height: 32),
                      _buildInputField(
                        controller: _emailController,
                        label: 'Email',
                        icon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 20),
                      _buildInputField(
                        controller: _passwordController,
                        label: 'Password',
                        icon: Icons.lock_outline,
                        obscureText: true,
                      ),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            // TODO: implement forgot password flow
                          },
                          child: const Text(
                            'Forgot password?',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF4facfe),
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 28),
                      _loading
                          ? const CircularProgressIndicator(
                            color: Color(0xFF4facfe),
                          )
                          : GestureDetector(
                            onTapDown: (_) => _btnAnimationController.forward(),
                            onTapUp: (_) {
                              _btnAnimationController.reverse();
                              _login();
                            },
                            onTapCancel:
                                () => _btnAnimationController.reverse(),
                            child: Transform.scale(
                              scale: scale,
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF4facfe),
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(
                                        0xFF4facfe,
                                      ).withAlpha(80),
                                      blurRadius: 12,
                                      offset: const Offset(0, 6),
                                    ),
                                  ],
                                ),
                                alignment: Alignment.center,
                                child: const Text(
                                  'Login',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    letterSpacing: 0.7,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      const SizedBox(height: 20),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const SignScreen(),
                            ),
                          );
                        },
                        child: Text(
                          "Don't have an account? Sign Up",
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.primary,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Material(
      elevation: 4,
      shadowColor: Colors.black26,
      borderRadius: BorderRadius.circular(16),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        style: const TextStyle(fontSize: 16),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: const Color(0xFF4facfe)),
          labelText: label,
          labelStyle: const TextStyle(color: Colors.grey),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }
}
