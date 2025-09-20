import 'dart:convert';
import 'package:http/http.dart' as http;

/// A service class that handles authentication-related API requests.
class AuthService {
  static const String _baseUrl = 'http://192.168.1.6:3003/api';

  Future<Map<String, dynamic>> login(String email, String password) async {
    final url = Uri.parse('$_baseUrl/users/login');
    try {
      final response = await http
          .post(
            url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'email': email, 'password': password}),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return {'success': true, 'data': jsonDecode(response.body)};
      } else {
        final error = jsonDecode(response.body);
        return {
          'success': false,
          'message': error['message'] ?? 'Login failed',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Unable to connect to server'};
    }
  }

  Future<void> logout() async {
    final url = Uri.parse('$_baseUrl/users/logout');
    try {
      await http.post(url);
    } catch (e) {
      print('Logout error: $e');
    }
  }

  Future<Map<String, dynamic>> signup(
    String name,
    String email,
    String password,
  ) async {
    final url = Uri.parse('$_baseUrl/users');
    print("🔗 Sending request to: $url");
    print('📡 Calling signup API...');

    try {
      final response = await http
          .post(
            url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'name': name,
              'email': email,
              'password': password,
            }),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 201) {
        return {'success': true, 'data': jsonDecode(response.body)};
      } else {
        final error = jsonDecode(response.body);
        return {
          'success': false,
          'message': error['message'] ?? 'Signup failed',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Unable to connect to server'};
    }
  }

  Future<Map<String, dynamic>> forgotPassword(String email) async {
    final url = Uri.parse('$_baseUrl/auth/forgot-password');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      final data = jsonDecode(response.body);
      return {
        'success': response.statusCode == 200,
        'message': data['message'] ?? 'OTP sent',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Unable to connect to server or invalid response',
      };
    }
  }

  Future<Map<String, dynamic>> verifyOtp(String email, String otp) async {
    final url = Uri.parse('$_baseUrl/auth/verify-otp');
    try {
      final response = await http
          .post(
            url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'email': email, 'otp': otp}),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {'success': true, 'message': data['message']};
      } else {
        final error = jsonDecode(response.body);
        return {'success': false, 'message': error['message'] ?? 'Invalid OTP'};
      }
    } catch (e) {
      print('Verify OTP error: $e');
      return {'success': false, 'message': 'Connection failed'};
    }
  }

  Future<Map<String, dynamic>> resetPassword(
    String email,
    String newPassword,
  ) async {
    final url = Uri.parse('$_baseUrl/auth/reset-password');
    try {
      final response = await http
          .post(
            url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'email': email, 'newPassword': newPassword}),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {'success': true, 'message': data['message']};
      } else {
        final error = jsonDecode(response.body);
        return {
          'success': false,
          'message': error['message'] ?? 'Reset failed',
        };
      }
    } catch (e) {
      print('Reset Password error: $e');
      return {'success': false, 'message': 'Connection failed'};
    }
  }
}
