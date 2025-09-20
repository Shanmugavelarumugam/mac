import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product_model.dart';

class ProductRepository {
  // ✅ Base URL defined at the top
  final String baseUrl =
      'https://store-kedb.onrender.com/api';

  final String token;

  ProductRepository({required this.token});

  // Create a product
  Future<Product> createProduct(Product product) async {
    final url = '$baseUrl/seller/product/';
    final body = jsonEncode([product.toJson()]); // ✅ wrap in array

    print('➡️ Creating product at $url');
    print('📦 Request body: $body');

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: body,
    );

    print('⬅️ Response status: ${response.statusCode}');
    print('⬅️ Response body: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      print('✅ Product created successfully: ${data[0]}');
      return Product.fromJson(data[0]); // backend returns array
    } else {
      print('❌ Failed to create product: ${response.body}');
      throw Exception('Failed to create product: ${response.body}');
    }
  }

  // Update a product by ID
  Future<void> updateProduct(
    int productId,
    Map<String, dynamic> updates,
  ) async {
    final url = '$baseUrl/seller/product/$productId';

    print('➡️ Updating product $productId at $url');
    print('📦 Updates: ${jsonEncode(updates)}');

    final response = await http.put(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(updates),
    );

    print('⬅️ Response status: ${response.statusCode}');
    print('⬅️ Response body: ${response.body}');

    if (response.statusCode != 200) {
      print('❌ Failed to update product: ${response.body}');
      throw Exception('Failed to update product: ${response.body}');
    } else {
      print('✅ Product updated successfully');
    }
  }

  // Soft-delete a product by ID
  Future<void> deleteProduct(int productId) async {
    final url = '$baseUrl/product/productid/$productId';

    print('➡️ Deleting product $productId at $url');

    final response = await http.delete(
      Uri.parse(url),
      headers: {'Authorization': 'Bearer $token'},
    );

    print('⬅️ Response status: ${response.statusCode}');
    print('⬅️ Response body: ${response.body}');

    if (response.statusCode != 200) {
      print('❌ Failed to delete product: ${response.body}');
      throw Exception('Failed to delete product: ${response.body}');
    } else {
      print('✅ Product deleted successfully');
    }
  }

  // Get all products by seller ID
  Future<List<Product>> getProductsBySeller(int sellerId) async {
    final url = '$baseUrl/seller/products/seller/$sellerId';

    print('➡️ Fetching products for seller $sellerId at $url');

    final response = await http.get(
      Uri.parse(url),
      headers: {'Authorization': 'Bearer $token'},
    );

    print('⬅️ Response status: ${response.statusCode}');
    print('⬅️ Response body: ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;
      print('✅ Fetched ${data.length} products');
      return data.map((json) => Product.fromJson(json)).toList();
    } else {
      print('❌ Failed to fetch products: ${response.body}');
      throw Exception('Failed to fetch products: ${response.body}');
    }
  }
}
