import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:btc_grocery/models/wishlist_item_model.dart';
import '../local/secure_storage_service.dart';

class WishlistService {
  final String baseUrl = 'http://192.168.1.6:3003/api/wishlist';
  final SecureStorageService _storage = SecureStorageService();

  Future<String?> _getToken() async {
    return await _storage.read(key: 'auth_token');
  }

  Future<List<WishlistItem>> getUserWishlist(int userId) async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/$userId'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => WishlistItem.fromJson(item)).toList();
    } else {
      throw Exception('Failed to fetch wishlist');
    }
  }

  Future<void> addToWishlist(int userId, int productId) async {
    final token = await _getToken();
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({'userId': userId, 'productId': productId}),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to add to wishlist');
    }
  }

  Future<void> removeFromWishlist(int wishlistItemId) async {
    final token = await _getToken();
    final response = await http.delete(
      Uri.parse('$baseUrl/$wishlistItemId'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to remove from wishlist');
    }
  }
}
