import 'package:shared_preferences/shared_preferences.dart';

class TokenManager {
  static const String _tokenKey = 'auth_token';
  static const String _timestampKey = 'token_timestamp';

  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    await prefs.setInt(
        _timestampKey, DateTime.now().toUtc().millisecondsSinceEpoch);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey);
    final timestamp = prefs.getInt(_timestampKey);

    if (token != null && timestamp != null) {
      final currentTime = DateTime.now().toUtc().hour;
      if (currentTime - timestamp < 8) {
        return token;
      } else {
        await clearToken();
      }
    }
    return null;
  }

  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_timestampKey);
  }
}
