import 'dart:convert';
import 'package:http/http.dart' as http;

class FinanceContactService {
  final String baseUrl =
      'https://art-tramadol-commodity-commands.trycloudflare.com/api/data/contacts';
  final int userId;

  FinanceContactService({required this.userId});

  // Get all contacts for the logged-in user
  Future<List<Map<String, dynamic>>> getContacts() async {
    print('Fetching contacts for userId: $userId');
    final response = await http.get(
      Uri.parse('$baseUrl/contacts/user/$userId'),
    );
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    if (response.statusCode == 200) {
      final decoded = List<Map<String, dynamic>>.from(
        json.decode(response.body),
      );
      print('Fetched ${decoded.length} contacts');
      return decoded;
    } else {
      throw Exception('Failed to fetch contacts');
    }
  }

  // Create a new contact
  Future<Map<String, dynamic>> createContact({
    required String name,
    required String phone,
    String? email,
  }) async {
    print(
      'Creating contact: name=$name, phone=$phone, email=$email, userId=$userId',
    );
    final response = await http.post(
      Uri.parse('$baseUrl/create'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'phone': phone,
        'email': email ?? '',
        'userId': userId,
      }),
    );
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    return jsonDecode(response.body);
  }

  // Add a transaction for a contact
  Future<Map<String, dynamic>> addTransaction({
    required int contactId,
    required String type, // 'pay' or 'get'
    required int amount,
    required String date,
    String? note,
  }) async {
    print(
      'Adding transaction: contactId=$contactId, type=$type, amount=$amount, date=$date, note=$note',
    );
    final response = await http.post(
      Uri.parse('$baseUrl/transaction'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'contactId': contactId,
        'type': type,
        'amount': amount,
        'date': date,
        'note': note ?? '',
      }),
    );
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    return jsonDecode(response.body);
  }

  // Get all transactions for a contact
  Future<List<Map<String, dynamic>>> getTransactions(int contactId) async {
    print('Fetching transactions for contactId: $contactId');
    final response = await http.get(
      Uri.parse('$baseUrl/transactions/$contactId'),
    );
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    if (response.statusCode == 200) {
      final decoded = List<Map<String, dynamic>>.from(
        json.decode(response.body),
      );
      print('Fetched ${decoded.length} transactions');
      return decoded;
    } else {
      throw Exception('Failed to fetch transactions');
    }
  }
}
