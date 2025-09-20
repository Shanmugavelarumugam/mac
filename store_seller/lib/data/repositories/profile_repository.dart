import 'dart:convert';
import 'package:btc_store/data/models/profile_model.dart';
import 'package:http/http.dart' as http;

class SellerRepository {
  final String baseUrl = "https://store-kedb.onrender.com/api/seller";
  final String token;

  SellerRepository({required this.token});

  Future<SellerProfile> getOwnProfile() async {
    final url = "$baseUrl/ownprofile";
    print('➡️ GET $url');
    print('🛡️ Headers: {"Authorization": "Bearer $token"}');

    final response = await http.get(
      Uri.parse(url),
      headers: {"Authorization": "Bearer $token"},
    );

    print('📥 Response => ${response.statusCode}: ${response.body}');

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print('✅ Profile loaded successfully');
      return SellerProfile.fromJson(data);
    } else {
      print('❌ Failed to load profile');
      throw Exception("Failed to load profile");
    }
  }

  Future<String> updateProfile(Map<String, dynamic> updateData) async {
    final url = "$baseUrl/update";
    print('➡️ PUT $url');
    print(
      '🛡️ Headers: {"Authorization": "Bearer $token", "Content-Type": "application/json"}',
    );
    print('📤 Payload: $updateData');

    final response = await http.put(
      Uri.parse(url),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: json.encode(updateData),
    );

    print('📥 Response => ${response.statusCode}: ${response.body}');

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print('✅ Profile updated successfully: ${data['message']}');
      return data['message'];
    } else {
      print('❌ Failed to update profile');
      throw Exception("Failed to update profile");
    }
  }
}
