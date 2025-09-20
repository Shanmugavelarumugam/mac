import 'package:hive/hive.dart';

class HiveService {
  static final _box = Hive.box('authBox');

  // Save login session
  static Future<void> saveLoginDetails({
    required String name,
    required String email,
    required int id,
    required String token,
  }) async {
    await _box.put('restaurantName', name);
    await _box.put('restaurantEmail', email);
    await _box.put('restaurantId', id);
    await _box.put('token', token);
    await _box.put('isLoggedIn', true);
  }

  // Getters
  static String get name => _box.get('restaurantName', defaultValue: 'N/A');
  static String get email => _box.get('restaurantEmail', defaultValue: 'N/A');
  static int get id => _box.get('restaurantId', defaultValue: -1);
  static String get token => _box.get('token', defaultValue: '');
  static bool get isLoggedIn => _box.get('isLoggedIn', defaultValue: false);

  // Clear all session
  
  static Future<void> logout() async {
    await _box.clear();
  }

  // Optional: async getter if needed elsewhere
  static Future<String> getTokenAsync() async {
    final box = await Hive.openBox('authBox');
    return box.get('token', defaultValue: '');
  }
}
