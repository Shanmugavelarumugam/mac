import 'package:btc_f/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'reset_password_screen.dart';

class VerifyOtpScreen extends StatefulWidget {
  final String email;
  const VerifyOtpScreen({super.key, required this.email});

  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen>
    with SingleTickerProviderStateMixin {
  final Dio dio = Dio();
  final List<TextEditingController> otpControllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> focusNodes = List.generate(6, (_) => FocusNode());

  bool isLoading = false;
  bool showError = false;

  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
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
    for (final c in otpControllers) {
      c.dispose();
    }
    for (final f in focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  Future<void> verifyOtp() async {
    final otp = otpControllers.map((c) => c.text).join();

    if (otp.length != 6 || otp.contains(RegExp(r'\D'))) {
      setState(() => showError = true);
      return;
    }

    setState(() {
      isLoading = true;
      showError = false;
    });

    try {
      final response = await dio.post(
        verifyOtpApi,
        data: {'email': widget.email, 'otp': otp},
      );


      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response.data['message'] ?? 'OTP Verified')),
      );

      await Future.delayed(const Duration(milliseconds: 300));
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ResetPasswordScreen(email: widget.email),
        ),
      );
    } catch (e) {
      if (e is DioError) {
        print('❌ Error Type: ${e.type}');
        print('❌ Error Message: ${e.message}');
        print('❌ Error Response: ${e.response?.data}');
        print('❌ Status Code: ${e.response?.statusCode}');
      } else {
        print('❌ Unexpected Error: $e');
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("OTP verification failed")));
    } finally {
      setState(() => isLoading = false);
    }
  }

  Widget buildOtpFields() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(6, (index) {
        return SizedBox(
          width: 45,
          child: TextField(
            controller: otpControllers[index],
            focusNode: focusNodes[index],
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            maxLength: 1,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            decoration: InputDecoration(
              counterText: '',
              filled: true,
              fillColor: Colors.grey[200],
              errorText:
                  showError &&
                          otpControllers[index].text.isEmpty &&
                          otpControllers.every((c) => c.text.isEmpty)
                      ? ''
                      : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
            onChanged: (value) {
              if (value.isNotEmpty && index < 5) {
                focusNodes[index + 1].requestFocus();
              } else if (value.isEmpty && index > 0) {
                focusNodes[index - 1].requestFocus();
              }
            },
          ),
        );
      }),
    );
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
        child: SafeArea(
          child: Stack(
            children: [
              // Back button
              Positioned(
                top: 0,
                left: 3,
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.white,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),

              // Centered card
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
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.verified,
                            size: 60,
                            color: Colors.deepOrange,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "OTP sent to ${widget.email}",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 24),
                          buildOtpFields(),
                          const SizedBox(height: 32),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: isLoading ? null : verifyOtp,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.deepOrange,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
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
                                        "Verify OTP",
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
        ),
      ),
    );
  }
}
