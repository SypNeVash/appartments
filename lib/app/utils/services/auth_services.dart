import 'package:apartments/app/utils/services/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../../api/token_control.dart';

class AuthService {
  static Future<bool> isAuthenticated() async {
    final prefs = await SPHelper.getTokenSharedPreference();
    return prefs != null && prefs.isNotEmpty;
  }

  Future<dynamic> login(String username, String password) async {
    Dio _dio = Dio();
    try {
      Response response = await _dio.post(
        'https://realtor.azurewebsites.net/api/Authenticate/login',
        data: {
          'username': username,
          'password': password,
        },
        // queryParameters: {'apikey': ApiSecret.apiKey},
      );
      final res = response.data;
      if (res['status'] != 401) {
        String accessToken = res['token'];
        String token = accessToken;
        Map<String, dynamic> decodedToken = JwtDecoder.decode(token);

        // bool isTokenExpired = JwtDecoder.isExpired(token);

        // if (isTokenExpired == true) {}

        await _saveToken(token, decodedToken);
      }
    } on DioError catch (e) {
      return e.response!.data;
    }
  }

  Future<void> _saveToken(String token, decodedToken) async {
    await SPHelper.saveTokenSharedPreference(token);
    final role = await getField('/identity/claims/role', decodedToken);
    await SPHelper.saveRoleSharedPreference(role);
    final name = await getField('/identity/claims/name', decodedToken);
    await SPHelper.saveNameSharedPreference(name);
    await TokenManager.saveToken(token);
  }

  Future<String> getField(String partialKey, token) async {
    try {
      // Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      String valueField = '';
      token.forEach((key, val) {
        if (key.contains(partialKey)) {
          valueField = val;
        }
      });
      return valueField;
    } catch (e) {
      return 'Error decoding token';
    }
  }

  static Future<void> logout() async {
    await SPHelper.removeTokenSharedPreference();
  }

  static Future<String?> getToken() async {
    final prefs = await SPHelper.getTokenSharedPreference();
    return prefs;
  }
}
