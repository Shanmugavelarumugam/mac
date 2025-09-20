import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:btc_grocery/services/api/auth_service.dart';
import 'package:btc_grocery/services/local/secure_storage_service.dart';
import 'package:btc_grocery/app/routes/app_routes.dart';

class AuthController extends GetxController {
  final AuthService _authService = AuthService();
  final SecureStorageService _storageService = Get.find<SecureStorageService>();

  final RxBool isLoading = false.obs;
  final RxBool isLoggedIn = false.obs;
  final RxString token = ''.obs;

  final RxString userName = ''.obs;
  final RxString userEmail = ''.obs;
  final RxString userRole = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _loadTokenAndUserDetails();
  }

  Future<void> _loadTokenAndUserDetails() async {
    final storedToken = await _storageService.getToken();
    final name = await _storageService.read(key: 'user_name');
    final email = await _storageService.read(key: 'user_email');
    final role = await _storageService.read(key: 'user_role');

    if (storedToken != null && storedToken.isNotEmpty) {
      token.value = storedToken;
      userName.value = name ?? '';
      userEmail.value = email ?? '';
      userRole.value = role ?? '';
      isLoggedIn.value = true;
    }
  }

  void _showSnackbar(String title, String message, {bool isError = false}) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: isError ? Colors.red.shade100 : Colors.green.shade100,
      colorText: Colors.black,
    );
  }

  Future<bool> login(String email, String password) async {
    isLoading.value = true;
    try {
      final result = await _authService.login(email, password);

      if (result == null) throw Exception('Empty response from server');

      final data = result['data'];
      if (data != null && data['token'] != null && data['user'] != null) {
        final authToken = data['token'];
        final user = data['user'];
        final userId = user['id']?.toString();
        final name = user['name'] ?? '';
        final role = user['role'] ?? '';

        if (authToken == null || userId == null) {
          throw Exception('Token or userId missing');
        }

        await _storageService.saveToken(authToken);
        await _storageService.saveUserId(userId);
        await _storageService.write(key: 'user_name', value: name);
        await _storageService.write(key: 'user_email', value: email);
        await _storageService.write(key: 'user_role', value: role);

        token.value = authToken;
        userName.value = name;
        userEmail.value = email;
        userRole.value = role;
        isLoggedIn.value = true;

        Get.offAllNamed(AppRouteNames.home);
        _showSnackbar('Success', 'Login successful');
        return true;
      } else {
        _showSnackbar(
          'Error',
          result['message'] ?? 'Login failed',
          isError: true,
        );
        return false;
      }
    } catch (e) {
      _showSnackbar('Error', 'Something went wrong: $e', isError: true);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> checkLogin() async {
    await _loadTokenAndUserDetails();

    if (token.value.isNotEmpty) {
      isLoggedIn.value = true;
      Get.offAllNamed(AppRouteNames.home);
    } else {
      isLoggedIn.value = false;
      Get.offAllNamed(AppRouteNames.login);
    }
  }

  Future<bool> signup(String name, String email, String password) async {
    isLoading.value = true;
    print('🟡 Signup started...');

    try {
      final result = await _authService.signup(name, email, password);
      print('✅ Signup API response: $result');

      if (result == null) throw Exception('Empty signup response');
     final data = result['data'];
      final authToken = ''; // No token returned for now
      final user = data; // Entire response is user object


      print('✅ Token: $authToken');
      print('✅ User: $user');

      if (user == null || user['id'] == null || authToken == null) {
        throw Exception('Signup token or userId missing');
      }

      final userId = user['id'].toString(); // now safe
      final role = user['role'] ?? '';

      if (authToken == null || userId == null) {
        throw Exception('Signup token or userId missing');
      }

      await _storageService.saveToken(authToken);
      await _storageService.saveUserId(userId);
      await _storageService.write(key: 'user_name', value: name);
      await _storageService.write(key: 'user_email', value: email);
      await _storageService.write(key: 'user_role', value: role);
      print('✅ Auth info saved locally');

      token.value = authToken;
      userName.value = name;
      userEmail.value = email;
      userRole.value = role;
      isLoggedIn.value = true;
      print('✅ Reactive values updated');

      Get.offAllNamed(AppRouteNames.home);
      print('✅ Navigation done');

      _showSnackbar('Success', 'Signup successful');
      print('✅ Snackbar shown');

      return true;
    } catch (e) {
      print('❌ Signup error: $e');
      _showSnackbar('Error', 'Something went wrong: $e', isError: true);
      return false;
    } finally {
      isLoading.value = false;
      print('🔚 Signup process finished');
    }
  }

  Future<bool> forgotPassword(String email) async {
    isLoading.value = true;
    try {
      final response = await _authService.forgotPassword(email);
      if (response['success'] == true) {
        Get.toNamed(AppRouteNames.verifyOtp, arguments: {'email': email});
        _showSnackbar('OTP Sent', 'Check your email for the OTP.');
        return true;
      } else {
        _showSnackbar(
          'Error',
          response['message'] ?? 'Failed to send OTP',
          isError: true,
        );
        return false;
      }
    } catch (e) {
      _showSnackbar('Error', 'Something went wrong: $e', isError: true);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> verifyOtp(String email, String otp) async {
    isLoading.value = true;
    try {
      final response = await _authService.verifyOtp(email, otp);
      if (response['success'] == true) {
        Get.toNamed(AppRouteNames.resetPassword, arguments: {'email': email});
      } else {
        _showSnackbar(
          'Error',
          response['message'] ?? 'Invalid OTP',
          isError: true,
        );
      }
    } catch (e) {
      _showSnackbar('Error', 'Verification failed: $e', isError: true);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resetPassword(String email, String newPassword) async {
    isLoading.value = true;
    try {
      final response = await _authService.resetPassword(email, newPassword);
      if (response['success'] == true) {
        Get.offAllNamed(AppRouteNames.login);
        _showSnackbar('Success', 'Password reset successful');
      } else {
        _showSnackbar(
          'Error',
          response['message'] ?? 'Reset failed',
          isError: true,
        );
      }
    } catch (e) {
      _showSnackbar('Error', 'Reset failed: $e', isError: true);
    } finally {
      isLoading.value = false;
    }
  }

  void resendOtp(String email) async {
    await forgotPassword(email);
  }

  void logout() async {
    await _authService.logout();
    await _storageService.clearAll();
    clearData();
    Get.offAllNamed(AppRouteNames.login);
  }

  void clearData() {
    token.value = '';
    isLoggedIn.value = false;
    userName.value = '';
    userEmail.value = '';
    userRole.value = '';
  }
}
