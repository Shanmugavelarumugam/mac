import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../models/product_model.dart';
import '../../../models/category_model.dart';

class ProductService {
  final storage = const FlutterSecureStorage();
  final String baseUrl = 'http://192.168.1.6:3003/api';

  Future<String?> _getToken() async {
    final token = await storage.read(key: 'auth_token');
    if (token == null) {
      print('⚠️ Token not found in secure storage.');
    } else {
      print('✅ Token retrieved: $token');
    }
    return token;
  }

  Future<ProductModel> fetchProductById(int id) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('⚠️ No token available for authorization.');
    }

    final res = await http.get(
      Uri.parse('$baseUrl/products/$id'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (res.statusCode == 200) {
      return ProductModel.fromJson(json.decode(res.body));
    } else {
      throw Exception('❌ Failed to fetch product: ${res.statusCode}');
    }
  }

  Future<List<CategoryModel>> fetchCategories() async {
    final token = await _getToken();
    if (token == null)
      throw Exception('⚠️ No token available for authorization.');

    try {
      final res = await http.get(
        Uri.parse('$baseUrl/categories'),
        headers: {'Authorization': 'Bearer $token'},
      );

      print('--- 🔍 Categories Response ---');
      print('Status Code: ${res.statusCode}');
      print('Body: ${res.body}');

      if (res.statusCode == 200) {
        final data = json.decode(res.body) as List;
        return data.map((e) => CategoryModel.fromJson(e)).toList();
      } else {
        throw Exception('❌ Failed to load categories (${res.statusCode})');
      }
    } catch (e) {
      print('🔥 Category fetch error: $e');
      rethrow;
    }
  }

  Future<List<ProductModel>> fetchProducts() async {
    final token = await _getToken();
    if (token == null)
      throw Exception('⚠️ No token available for authorization.');

    try {
      final res = await http.get(
        Uri.parse('$baseUrl/products'),
        headers: {'Authorization': 'Bearer $token'},
      );

      print('--- 🔍 Products Response ---');
      print('Status Code: ${res.statusCode}');
      print('Body: ${res.body}');

      if (res.statusCode == 200) {
        final data = json.decode(res.body) as List;
        return data.map((e) => ProductModel.fromJson(e)).toList();
      } else {
        throw Exception('❌ Failed to load products (${res.statusCode})');
      }
    } catch (e) {
      print('🔥 Product fetch error: $e');
      rethrow;
    }
  }
}
