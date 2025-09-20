import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  final String baseUrl = 'https://scientist-galaxy-protocols-arkansas.trycloudflare.com/api/users';

  Future<Map<String, dynamic>> registerUser({
    required String username,
    required String email,
    required String password,
  }) async {
    print('Registering user: username=$username, email=$email');
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'name': username, // ✅ changed from 'username' to 'name'
        'email': email,
        'password': password,
      }),
    );
    print('Register response status: ${response.statusCode}');
    print('Register response body: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      final decoded = json.decode(response.body);
      print('Register success: $decoded');
      return decoded;
    } else {
      throw Exception('Registration failed: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> loginUser({
    required String email,
    required String password,
  }) async {
    print('Logging in user with email: $email');
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email, 'password': password}),
    );
    print('Login response status: ${response.statusCode}');
    print('Login response body: ${response.body}');

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      print('Login success: $decoded');
      return decoded;
    } else {
      throw Exception('Login failed: ${response.body}');
    }
  }
}
