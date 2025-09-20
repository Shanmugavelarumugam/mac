import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/auth_model.dart';

class AuthRepository {
  final String baseUrl = 'https://store-kedb.onrender.com/api/seller';

  Future<AuthResponse> register({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String businessName,
  }) async {
    final bodyData = {
      "name": name,
      "email": email,
      "phone": phone,
      "password": password,
      "businessName": businessName,
    };

    print("Register Request Body: $bodyData");

    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(bodyData),
    );

    print("Register Response Status: ${response.statusCode}");
    print("Register Response Body: ${response.body}");

    final body = jsonDecode(response.body);
    final authResponse = AuthResponse.fromJson(body);

    print(
      "Parsed Register Response: Token=${authResponse.token}, Seller Name=${authResponse.seller?.name ?? 'null'}",
    );

    return authResponse;
  }

  Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    final bodyData = {"email": email, "password": password};

    print("Login Request Body: $bodyData");

    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(bodyData),
    );

    print("Login Response Status: ${response.statusCode}");
    print("Login Response Body: ${response.body}");

    final body = jsonDecode(response.body);
    final authResponse = AuthResponse.fromJson(body);

    print(
      "Parsed Login Response: Token=${authResponse.token}, Seller Name=${authResponse.seller?.name ?? 'null'}",
    );

    return authResponse;
  }
}
