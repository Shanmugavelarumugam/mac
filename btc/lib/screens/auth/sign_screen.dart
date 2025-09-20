import 'package:btc/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SignScreen extends StatefulWidget {
  const SignScreen({Key? key}) : super(key: key);

  @override
  _SignScreenState createState() => _SignScreenState();
}

class _SignScreenState extends State<SignScreen>
    with SingleTickerProviderStateMixin {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

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
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    setState(() => _loading = true);
    try {
      final result = await _authService.registerUser(
        username: _usernameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      // Save to secure storage
      await _storage.write(
        key: "username",
        value: _usernameController.text.trim(),
      );
      print("Saved username: ${_usernameController.text.trim()}");

      await _storage.write(key: "email", value: _emailController.text.trim());
      print("Saved email: ${_emailController.text.trim()}");

      await _storage.write(
        key: "password",
        value: _passwordController.text,
      ); // store cautiously
      print("Saved password: ${_passwordController.text}");

      // Read back to verify
      String? savedUsername = await _storage.read(key: "username");
      String? savedEmail = await _storage.read(key: "email");
      String? savedPassword = await _storage.read(key: "password");

      print("Read back username: $savedUsername");
      print("Read back email: $savedEmail");
      print("Read back password: $savedPassword");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'] ?? 'Registration successful')),
      );

      Navigator.pop(context); // Return to login
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Registration failed: $e')));
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
                        Icons.person_add_alt_1,
                        size: 72,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Create Account',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.7,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Sign up to get started!',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: Colors.grey[700],
                          letterSpacing: 0.4,
                        ),
                      ),
                      const SizedBox(height: 32),

                      _buildInputField(
                        controller: _usernameController,
                        label: 'Username',
                        icon: Icons.person_outline,
                        keyboardType: TextInputType.name,
                      ),
                      const SizedBox(height: 20),

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
                      const SizedBox(height: 32),

                      _loading
                          ? const CircularProgressIndicator(
                            color: Color(0xFF4facfe),
                          )
                          : GestureDetector(
                            onTapDown: (_) => _btnAnimationController.forward(),
                            onTapUp: (_) {
                              _btnAnimationController.reverse();
                              _register();
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
                                  'Register',
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
