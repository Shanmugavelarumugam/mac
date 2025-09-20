import 'dart:convert';
import 'package:http/http.dart' as http;

class PeopleService {
  final String baseUrl =
      "https://art-tramadol-commodity-commands.trycloudflare.com/api/data/people";

  // Get all people for a specific user
  Future<List<Map<String, dynamic>>> getPeopleByUser(int userId) async {
    final response = await http.get(Uri.parse("$baseUrl/user/$userId"));
    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      throw Exception("Failed to fetch people for user $userId");
    }
  }

  // Create a new person for a specific user
  Future<Map<String, dynamic>> createPerson(String name, int userId) async {
    final response = await http.post(
      Uri.parse("$baseUrl/create"),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({"name": name, "expenses": 0, "userId": userId}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Map<String, dynamic>.from(json.decode(response.body));
    } else {
      throw Exception("Failed to create person for user $userId");
    }
  }

  // Add a transaction for a person and user
  Future<Map<String, dynamic>> addTransaction({
    required int peopleId,
    required int userId,
    required double amount,
    required String purpose,
    required String date,
  }) async {
    final response = await http.post(
      Uri.parse("$baseUrl/addTransaction"),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        "peopleId": peopleId,
        "userId": userId,
        "amount": amount,
        "purpose": purpose,
        "date": date,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Map<String, dynamic>.from(json.decode(response.body));
    } else {
      throw Exception(
        "Failed to add transaction for person $peopleId, user $userId",
      );
    }
  }
}
