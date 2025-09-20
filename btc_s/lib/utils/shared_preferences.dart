import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static const String _tokenKey = 'authToken';
  static const String _nameKey = 'userName';
  static const String _emailKey = 'userEmail';
  static const String _userIdKey = 'userId';

  static const String _recentlyViewedKey = 'recentlyViewedProducts';
  static const int _recentlyViewedLimit = 20;

  static const String _recentSearchKey = 'recentSearchHistory';
  static const int _recentSearchLimit = 10;

  // ✅------------------- Recently Viewed -------------------

  static Future<void> addRecentlyViewed(Map<String, dynamic> newProduct) async {
    final prefs = await SharedPreferences.getInstance();
    final existing = prefs.getString(_recentlyViewedKey);

    List<Map<String, dynamic>> productList = [];

    if (existing != null) {
      final decoded = jsonDecode(existing) as List;
      productList = decoded.cast<Map<String, dynamic>>();
    }

    productList.removeWhere((item) => item['id'] == newProduct['id']);
    productList.insert(0, newProduct);

    final limitedList = productList.take(_recentlyViewedLimit).toList();
    await prefs.setString(_recentlyViewedKey, jsonEncode(limitedList));
  }

  static Future<List<Map<String, dynamic>>> getRecentlyViewed() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_recentlyViewedKey);
    if (jsonString == null) return [];
    final List decoded = jsonDecode(jsonString);
    return decoded.cast<Map<String, dynamic>>();
  }

  static Future<void> clearRecentlyViewed() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_recentlyViewedKey);
  }

  // ✅------------------- Recent Search History -------------------

  static Future<void> addRecentSearch(String query) async {
    final prefs = await SharedPreferences.getInstance();
    final existing = prefs.getStringList(_recentSearchKey) ?? [];

    existing.remove(query); // Remove if duplicate
    existing.insert(0, query); // Add to top

    final limited = existing.take(_recentSearchLimit).toList();
    await prefs.setStringList(_recentSearchKey, limited);
  }

  static Future<List<String>> getRecentSearches() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_recentSearchKey) ?? [];
  }

  static Future<void> clearRecentSearches() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_recentSearchKey);
  }

  // ✅ ADD THIS: Save full recent search list
  static Future<void> saveRecentSearches(List<String> list) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _recentSearchKey,
      list.take(_recentSearchLimit).toList(),
    );
  }

  // ✅------------------- Token -------------------

  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  static Future<void> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }

  // ✅------------------- User ID -------------------

  static Future<void> saveUserId(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userIdKey, userId);
  }

  static Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userIdKey);
  }

  static Future<void> removeUserId() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userIdKey);
  }

  // ✅------------------- Name -------------------

  static Future<void> saveUserName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_nameKey, name);
  }

  static Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_nameKey);
  }

  static Future<void> removeUserName() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_nameKey);
  }

  // ✅------------------- Email -------------------

  static Future<void> saveUserEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_emailKey, email);
  }

  static Future<String?> getUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_emailKey);
  }

  static Future<void> removeUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_emailKey);
  }

  // ✅------------------- Clear All -------------------

  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  static saveRecentlyViewed(List<Map<String, dynamic>> list) {}
}
