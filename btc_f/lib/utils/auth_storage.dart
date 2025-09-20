import 'package:btc_f/data/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthStorage {
 static Future<void> saveAuthData(String token, User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    await prefs.setString('userEmail', user.email);
    await prefs.setString('userName', user.name);
    await prefs.setInt('userId', user.id);
  }


  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userName');
  }

  static Future<String?> getUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userEmail');
  }

  static Future<void> clearAuthData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
