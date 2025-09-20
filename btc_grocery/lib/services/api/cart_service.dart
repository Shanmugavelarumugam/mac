import 'dart:convert';
import 'package:btc_grocery/models/cart_item_model.dart';
import 'package:btc_grocery/services/local/secure_storage_service.dart';
import 'package:http/http.dart' as http;

class CartService {
  final baseUrl = "http://192.168.1.6:3003/api/cart";

  Future<List<CartItem>> getCart(int userId) async {
    final token = await SecureStorageService().getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/$userId'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as List;
      return data.map((e) => CartItem.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load cart");
    }
  }

  Future<void> addToCart(Map<String, dynamic> data) async {
    final token = await SecureStorageService().getToken();
    await http.post(
      Uri.parse(baseUrl),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode(data),
    );
  }

  Future<void> updateCartItem(int itemId, int quantity) async {
    final token = await SecureStorageService().getToken();
    await http.put(
      Uri.parse('$baseUrl/$itemId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({'quantity': quantity}),
    );
  }

  Future<void> deleteCartItem(int itemId) async {
    final token = await SecureStorageService().getToken();
    await http.delete(
      Uri.parse('$baseUrl/$itemId'),
      headers: {'Authorization': 'Bearer $token'},
    );
  }
}
