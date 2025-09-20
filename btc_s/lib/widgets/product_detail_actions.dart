import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../utils/constants.dart';
import '../utils/shared_preferences.dart';

class ProductDetailActions {
  static Future<void> checkIfWishlisted({
    required BuildContext context,
    required int productId,
    required Function(bool, int?) onWishlisted,
  }) async {
    final userId = await UserPreferences.getUserId();
    if (userId == null) return;

    final String apiUrl = '${AppConstants.baseUrl}/api/liked/$userId';
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final List<dynamic> likedItems = jsonDecode(response.body);
        final existing = likedItems.firstWhere(
          (item) => item['ProductId'] == productId,
          orElse: () => null,
        );
        onWishlisted(existing != null, existing?['id']);
      }
    } catch (e) {
      print('Error checking wishlist: $e');
    }
  }

  static Future<void> toggleWishlist({
    required BuildContext context,
    required int productId,
    required bool isWishlisted,
    required int? wishlistId,
    required Function(bool, int?) onUpdated,
  }) async {
    final userId = await UserPreferences.getUserId();
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please log in to manage wishlist')),
      );
      return;
    }

    if (!isWishlisted) {
      final String addUrl = '${AppConstants.baseUrl}/api/liked/add';
      final response = await http.post(
        Uri.parse(addUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'userId': userId, 'productId': productId}),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        onUpdated(true, data['likedItem']['id']);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Added to wishlist')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to add to wishlist')),
        );
      }
    } else {
      final String deleteUrl = '${AppConstants.baseUrl}/api/liked/$wishlistId';
      final response = await http.delete(Uri.parse(deleteUrl));
      if (response.statusCode == 200) {
        onUpdated(false, null);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Removed from wishlist')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to remove from wishlist')),
        );
      }
    }
  }

  static Future<void> addToCart({
    required BuildContext context,
    required int productId,
    required int quantity,
  }) async {
    final userId = await UserPreferences.getUserId();
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please log in to add items to cart')),
      );
      return;
    }

    final String apiUrl = '${AppConstants.baseUrl}/api/cart/add';
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'userId': userId,
        'productId': productId,
        'quantity': quantity,
      }),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product added to cart successfully')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to add to cart (${response.statusCode})'),
        ),
      );
    }
  }
}
