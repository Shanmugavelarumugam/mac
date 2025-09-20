import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/brand_model.dart';

class BrandRepository {
  final String token;
  final String baseUrl;

  BrandRepository({
    required this.token,
    this.baseUrl = "https://store-kedb.onrender.com/api",
  });

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token',
  };

  Future<Brand> createBrand(Brand brand) async {
    print("Creating brand: ${brand.toJson()}");
    final response = await http.post(
      Uri.parse('$baseUrl/seller/brands'),
      headers: _headers,
      body: jsonEncode([brand.toJson()]), // API expects an array
    );

    print("Response status: ${response.statusCode}");
    print("Response body: ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body)[0];
      print("Parsed brand: $data");
      return Brand.fromJson(data);
    } else {
      throw Exception('Failed to create brand: ${response.body}');
    }
  }

  Future<Brand> updateBrand(int id, Map<String, dynamic> updates) async {
    print("Updating brand $id with: $updates");
    final response = await http.put(
      Uri.parse('$baseUrl/brand/$id'),
      headers: _headers,
      body: jsonEncode(updates),
    );

    print("Response status: ${response.statusCode}");
    print("Response body: ${response.body}");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print("Updated brand: $data");
      return Brand.fromJson(data);
    } else {
      throw Exception('Failed to update brand: ${response.body}');
    }
  }

  Future<void> deleteBrand(int id) async {
    print("Deleting brand with id: $id");
    final response = await http.delete(
      Uri.parse('$baseUrl/brand/$id'),
      headers: _headers,
    );

    print("Response status: ${response.statusCode}");
    print("Response body: ${response.body}");

    if (response.statusCode != 200) {
      throw Exception('Failed to delete brand: ${response.body}');
    } else {
      print("Brand deleted successfully");
    }
  }
  Future<List<Brand>> getBrandsBySellerId(int sellerId) async {
    print("Fetching brands for sellerId: $sellerId");
    final response = await http.get(
      Uri.parse('$baseUrl/seller/brands/seller/$sellerId'),
      headers: _headers,
    );

    print("Response status: ${response.statusCode}");
    print("Response body: ${response.body}");

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      final brands = data.map((e) => Brand.fromJson(e)).toList();
      print("Parsed brands: ${brands.map((b) => b.toJson())}");
      return brands;
    } else {
      throw Exception('Failed to fetch brands: ${response.body}');
    }
  }

}
