import 'package:btc_f/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'verify_otp_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController emailController = TextEditingController();
  final Dio dio = Dio();
  bool isLoading = false;
  bool showError = false;

  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Animation setup
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    emailController.dispose();
    super.dispose();
  }

  Future<void> sendResetEmail() async {
    final email = emailController.text.trim();
    if (email.isEmpty || !email.contains('@')) {
      setState(() => showError = true);
      return;
    }

    setState(() {
      isLoading = true;
      showError = false;
    });

    try {
      final response = await dio.post(
        forgotPasswordApi,
        data: {'email': email},
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response.data['message'] ?? 'OTP sent')),
      );

      await Future.delayed(const Duration(milliseconds: 300));
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => VerifyOtpScreen(email: email)),
      );
    } catch (e) {
      if (e is DioError) {
        print("❌ DioError: ${e.message}");
        print("❌ Response: ${e.response?.data}");
        print("❌ Status: ${e.response?.statusCode}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.response?.data['message'] ?? "Failed to send OTP"),
          ),
        );
      } else {
        print("❌ Unknown Error: $e");
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Something went wrong")));
      }
    }

  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // Gradient background
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.orange, Colors.deepOrangeAccent],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          // iOS back button (top-left)
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 8.0),
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.white,
                  size: 24,
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),

          // Centered animated card
          Center(
            child: SingleChildScrollView(
              child: ScaleTransition(
                scale: _animation,
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.lock_reset,
                        size: 60,
                        color: Colors.deepOrange,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        "Forgot Password? 🔐",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Enter your email to receive a one-time password (OTP).",
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),

                      TextField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        autocorrect: false,
                        textCapitalization: TextCapitalization.none,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey[200],
                          labelText: "Email",
                          prefixIcon: const Icon(Icons.email_outlined),
                          errorText:
                              showError ? "Please enter a valid email" : null,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: isLoading ? null : sendResetEmail,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepOrange,
                            padding: const EdgeInsets.symmetric(vertical: 16),
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
                                    "Send OTP",
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
        ],
      ),
    );
  }
}
