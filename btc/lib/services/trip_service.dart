import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/trip.dart';
import '../models/transaction.dart';

class TripService {
  final String baseUrl =
      'https://art-tramadol-commodity-commands.trycloudflare.com/api/data/trip';

  Future<Trip> createTrip(
    String place,
    String date,
    List<String> members,
    int userId,
  ) async {
    final url = '$baseUrl/create';
    print('➡️ [POST] $url');
    print(
      '📦 Request body: ${json.encode({'place': place, 'date': date, 'members': members, 'userId': userId})}',
    );

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'place': place,
        'date': date,
        'members': members,
        'userId': userId,
      }),
    );

    print('✅ Response status: ${response.statusCode}');
    print('📄 Response body: ${response.body}');

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to create trip: ${response.body}');
    }

    return Trip.fromJson(json.decode(response.body));
  }

  Future<TripTransaction> addTransaction(
    int tripId,
    String name,
    double amount,
    String purpose,
    String date,
  ) async {
    final url = '$baseUrl/addTransaction';
    print('➡️ [POST] $url');
    print(
      '📦 Request body: ${json.encode({'tripId': tripId, 'name': name, 'amount': amount, 'purpose': purpose, 'date': date})}',
    );

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'tripId': tripId,
        'name': name,
        'amount': amount,
        'purpose': purpose,
        'date': date,
      }),
    );

    print('✅ Response status: ${response.statusCode}');
    print('📄 Response body: ${response.body}');

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to add transaction: ${response.body}');
    }

    return TripTransaction.fromJson(json.decode(response.body));
  }

  Future<Trip> getTripById(int tripId) async {
    final url = '$baseUrl/trips/$tripId';
    print('➡️ [GET] $url');

    final response = await http.get(Uri.parse(url));

    print('✅ Response status: ${response.statusCode}');
    print('📄 Response body: ${response.body}');

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch trip details: ${response.body}');
    }
    return Trip.fromJson(json.decode(response.body));
  }

  Future<Trip> updateTrip(
    int tripId,
    String place,
    List<String> members,
  ) async {
    final url = '$baseUrl/trips/$tripId';
    print('➡️ [PUT] $url');
    print(
      '📦 Request body: ${json.encode({'place': place, 'members': members})}',
    );

    final response = await http.put(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'place': place, 'members': members}),
    );

    print('✅ Response status: ${response.statusCode}');
    print('📄 Response body: ${response.body}');

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to update trip: ${response.body}');
    }

    final jsonData = json.decode(response.body);
    return Trip.fromJson(jsonData['trip']);
  }

  Future<Map<String, dynamic>> getSettlement(int tripId) async {
    final url = '$baseUrl/settlement/$tripId';
    print('➡️ [GET] $url');

    final response = await http.get(Uri.parse(url));

    print('✅ Response status: ${response.statusCode}');
    print('📄 Response body: ${response.body}');

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch settlement: ${response.body}');
    }

    return json.decode(response.body);
  }

  Future<List<Trip>> getTripsByUserId(int userId) async {
    final url = '$baseUrl/trips/user/$userId';
    print('➡️ [GET] $url');

    final response = await http.get(Uri.parse(url));

    print('✅ Response status: ${response.statusCode}');
    print('📄 Response body: ${response.body}');

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch trips: ${response.body}');
    }

    final List jsonList = json.decode(response.body);
    return jsonList.map((e) => Trip.fromJson(e)).toList();
  }

  Future<void> deleteTrip(int tripId) async {
    final url = '$baseUrl/trips/$tripId';
    print('➡️ [DELETE] $url');

    final response = await http.delete(Uri.parse(url));

    print('✅ Response status: ${response.statusCode}');
    print('📄 Response body: ${response.body}');

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to delete trip: ${response.body}');
    }
  }
}
