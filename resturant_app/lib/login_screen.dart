import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:resturant_app/dashboard/dashboard_screen.dart';
import 'package:resturant_app/services/hive_service.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> login(BuildContext context) async {
    final String url = 'http://192.168.1.4:3001/api/restaurants/login';

    if (!_formKey.currentState!.validate()) return;
    setState(() => isLoading = true);

    try {
      final response = await Dio().post(
        url,
        data: {
          "email": emailController.text.trim(),
          "password": passwordController.text.trim(),
        },
        options: Options(
          sendTimeout: const Duration(seconds: 5),
          receiveTimeout: const Duration(seconds: 5),
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final restaurant = data['restaurant'];
        final token = data['token'];

        // ✅ Save restaurant info & token to Hive
        await HiveService.saveLoginDetails(
          name: restaurant['name'] ?? 'Unknown',
          email: restaurant['email'] ?? '',
          id: restaurant['id'] ?? -1,
          token: token, // <-- token stored
        );

        // Navigate to Dashboard
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const DashboardScreen()),
        );
      } else {
        showError("Login failed");
      }
    } on DioError catch (e) {
      String errorMsg = "Login error";
      if (e.type == DioErrorType.sendTimeout ||
          e.type == DioErrorType.receiveTimeout) {
        errorMsg = "Server timeout. Please try again.";
      } else if (e.response?.statusCode == 401) {
        errorMsg = "Invalid credentials.";
      }
      showError(errorMsg);
    } catch (e) {
      showError("Unexpected error: ${e.toString()}");
    } finally {
      setState(() => isLoading = false);
    }
  }

  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.redAccent),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Card(
            elevation: 12,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.restaurant_menu,
                      size: 80,
                      color: Colors.deepOrange,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Restaurant Login",
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        labelText: "Email",
                        prefixIcon: const Icon(Icons.email),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Email is required';
                        }
                        if (!value.contains('@')) {
                          return 'Enter a valid email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        labelText: "Password",
                        prefixIcon: const Icon(Icons.lock),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Password is required';
                        }
                        if (value.length < 4) {
                          return 'Password must be at least 4 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : () => login(context),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          backgroundColor: Colors.deepOrange,
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
                                  "Login",
                                  style: TextStyle(fontSize: 16),
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
    );
  }
}
