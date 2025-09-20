// dashboard_repository.dart
import 'dart:convert';
import 'package:btc_store/data/models/seller_dashboard_model.dart';
import 'package:http/http.dart' as http;
import '../models/dashboard_model.dart';

class DashboardRepository {
  final String baseUrl = "https://store-kedb.onrender.com/api/seller/dashboard";
  final String token;

  DashboardRepository({required this.token});

  Future<SellerDashboardModel> getSellerDashboard() async {
    final response = await http.get(
      Uri.parse("$baseUrl/seller"),
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return SellerDashboardModel.fromJson(data); // ✅ use correct class
    } else {
      throw Exception("Failed to load dashboard");
    }
  }
}
