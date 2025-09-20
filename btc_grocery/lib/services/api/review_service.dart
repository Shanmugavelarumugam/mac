import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../models/review_model.dart';

class ReviewService {
  final storage = const FlutterSecureStorage();
  final String baseUrl = 'http://192.168.1.6:3003/api';

  Future<String?> _getToken() => storage.read(key: 'auth_token');

  /// Fetch all reviews for a product
  Future<List<Review>> fetchReviews(int productId) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Authentication token not found');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/reviews/$productId'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((e) => Review.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load reviews: ${response.statusCode}');
    }
  }

  /// Add a new review
  Future<Review> addReview({
    required int userId,
    required int productId,
    required int rating,
    required String comment,
  }) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Authentication token not found');
    }

    final response = await http.post(
      Uri.parse('$baseUrl/reviews'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'userId': userId,
        'productId': productId,
        'rating': rating,
        'comment': comment,
      }),
    );

    if (response.statusCode == 201) {
      return Review.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to add review: ${response.statusCode}');
    }
  }

  /// Update a review
  Future<Review> updateReview({
    required int reviewId,
    required int rating,
    required String comment,
  }) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Authentication token not found');
    }

    final response = await http.put(
      Uri.parse('$baseUrl/reviews/$reviewId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({'rating': rating, 'comment': comment}),
    );

    if (response.statusCode == 200) {
      return Review.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update review: ${response.statusCode}');
    }
  }

  /// Delete a review
  Future<void> deleteReview(int reviewId) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Authentication token not found');
    }

    final response = await http.delete(
      Uri.parse('$baseUrl/reviews/$reviewId'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete review: ${response.statusCode}');
    }
  }

}
