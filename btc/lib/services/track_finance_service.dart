import 'dart:convert';
import 'package:http/http.dart' as http;

class TrackFinanceService {
  final String baseUrl =
      'https://art-tramadol-commodity-commands.trycloudflare.com/api/data/goals';

  // Create new goal for a specific user
  Future<Map<String, dynamic>> createGoal({
    required String title,
    required int targetAmount,
    required String dueDate,
    required int userId,
    String? note,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/create'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'title': title,
        'targetAmount': targetAmount,
        'dueDate': dueDate,
        'userId': userId,
        'note': note ?? '',
      }),
    );
    return jsonDecode(response.body);
  }

  // Add amount to an existing goal
  Future<Map<String, dynamic>> addAmount({
    required int goalId,
    required int amount,
    required String date,
    String? note,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/addAmount'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'goalId': goalId,
        'amount': amount,
        'date': date,
        'note': note ?? '',
      }),
    );
    return jsonDecode(response.body);
  }

  // Get all goals for a specific user
  Future<List<Map<String, dynamic>>> getGoalsByUser(int userId) async {
    final response = await http.get(Uri.parse('$baseUrl/user/$userId'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception('Failed to fetch goals for user $userId');
    }
  }

  // Get goal history by goalId
  Future<List<Map<String, dynamic>>> getGoalHistory(int goalId) async {
    final response = await http.get(Uri.parse('$baseUrl/history/$goalId'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception('Failed to fetch history for goal $goalId');
    }
  }
}
