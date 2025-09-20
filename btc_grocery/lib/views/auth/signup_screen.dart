import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../controllers/auth_controller.dart';

class SignupScreen extends StatefulWidget {
  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();
  final AuthController _authController = Get.find<AuthController>();
  final RxBool _obscurePassword = true.obs;
  final RxBool _obscureConfirmPassword = true.obs;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate()) {
      _authController.signup(
        _name.text.trim(),
        _email.text.trim(),
        _password.text.trim(),
      );
    }
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) return 'Email is required';
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) return 'Enter a valid email';
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.trim().isEmpty) return 'Password is required';
    if (value.trim().length < 8) return 'Min 8 characters required';
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.trim().isEmpty)
      return 'Please re-enter password';
    if (value.trim() != _password.text.trim()) return 'Passwords do not match';
    return null;
  }

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) return 'Name is required';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          keyboardDismissBehavior:
              ScrollViewKeyboardDismissBehavior.onDrag, // 👈 Added

          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () => Get.back(),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.black,
                          size: 30,
                        ),
                        SizedBox(width: 4),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Icon(
                  Icons.person_add_alt_1,
                  size: 80,
                  color: Colors.deepPurple,
                ),
                const SizedBox(height: 20),
                Text(
                  'Create an Account',
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),

               _buildTextField(
                  label: 'Name',
                  icon: Icons.person,
                  controller: _name,
                  validator: _validateName,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.name,
                  // 👇 Add textCapitalization here
                  textCapitalization: TextCapitalization.words,
                ),

                const SizedBox(height: 20),

                _buildTextField(
                  label: 'Email',
                  icon: Icons.email_outlined,
                  controller: _email,
                  validator: _validateEmail,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.emailAddress,
                ),

                const SizedBox(height: 20),

                Obx(
                  () => _buildTextField(
                    label: 'Password',
                    icon: Icons.lock_outline,
                    controller: _password,
                    validator: _validatePassword,
                    obscureText: _obscurePassword.value,
                    toggleObscureText:
                        () => _obscurePassword.value = !_obscurePassword.value,
                    textInputAction: TextInputAction.next,
                    helperText:
                        'At least 8 characters, include letters & numbers',
                  ),
                ),

                const SizedBox(height: 20),

                Obx(
                  () => _buildTextField(
                    label: 'Re-enter Password',
                    icon: Icons.lock_outline,
                    controller: _confirmPassword,
                    validator: _validateConfirmPassword,
                    obscureText: _obscureConfirmPassword.value,
                    toggleObscureText:
                        () =>
                            _obscureConfirmPassword.value =
                                !_obscureConfirmPassword.value,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => _submit(),
                  ),
                ),

                const SizedBox(height: 30),

                Obx(
                  () => ElevatedButton(
                    onPressed: _authController.isLoading.value ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child:
                        _authController.isLoading.value
                            ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                            : Text(
                              'Sign Up',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                  ),
                ),

                const SizedBox(height: 20),

                Center(
                  child: RichText(
                    text: TextSpan(
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                      children: [
                        const TextSpan(text: 'Already have an account? '),
                        TextSpan(
                          text: 'Login',
                          style: const TextStyle(
                            color: Colors.deepPurple,
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.w600,
                          ),
                          recognizer:
                              TapGestureRecognizer()..onTap = () => Get.back(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    required String? Function(String?) validator,
    TextInputType keyboardType = TextInputType.text,
    TextInputAction textInputAction = TextInputAction.done,
    bool obscureText = false,
    VoidCallback? toggleObscureText,
    void Function(String)? onFieldSubmitted,
    String? helperText,
    TextCapitalization textCapitalization =
        TextCapitalization.none, // 👈 Add this
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      onFieldSubmitted: onFieldSubmitted,
      textCapitalization: textCapitalization, // 👈 Use it here
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        suffixIcon:
            toggleObscureText != null
                ? IconButton(
                  icon: Icon(
                    obscureText ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: toggleObscureText,
                )
                : null,
        helperText: helperText,
        helperStyle: const TextStyle(fontSize: 12),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.grey.shade100,
      ),
    );
  }
}
