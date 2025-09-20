import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:web_app/data/model/image_result_model.dart';
import 'package:web_app/data/model/search_result_model.dart';

class SearchRepository {
  final String baseUrl;

  SearchRepository({required this.baseUrl});

  // Search text results
  Future<List<SearchResult>> search(
    String query, {
    int page = 1,
    int limit = 20, // updated limit
  }) async {
    final url = Uri.parse(
      '$baseUrl/search/?q=$query&page=$page&limit=$limit',
    ); // ✅ text search endpoint
    print("🔍 Calling Search API: $url");

    final response = await http.get(url);

    print("📡 Response status (search): ${response.statusCode}");

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final results = data['results'] as List;
      print("✅ Search results count: ${results.length}");
      return results.map((e) => SearchResult.fromJson(e)).toList();
    } else {
      print("❌ Failed Search API call: ${response.body}");
      throw Exception("Failed to fetch search results");
    }
  }

  // Search image results
  Future<List<ImageResult>> searchImages(
    String query, {
    int page = 1,
    int limit = 20, // updated limit
  }) async {
    final url = Uri.parse(
      '$baseUrl/search_images/?q=$query&page=$page&limit=$limit',
    ); // ✅ image search endpoint
    print("🖼️ Calling Image Search API: $url");

    final response = await http.get(url);

    print("📡 Response status (images): ${response.statusCode}");

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final results = data['results'] as List;
      print("✅ Image search results count: ${results.length}");
      return results.map((e) => ImageResult.fromJson(e)).toList();
    } else {
      print("❌ Failed Image Search API call: ${response.body}");
      throw Exception("Failed to fetch image results");
    }
  }
}
