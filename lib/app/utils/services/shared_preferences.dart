import 'package:shared_preferences/shared_preferences.dart';

class SPHelper {
  static String sharedPreferenceUserIdKey = "USERIDEKEY";
  static String sharedPreferenceApartmentIdKey = "APARTID";
  static String sharedPreferenceRoleIdKey = "ROLE";
  static String sharedPreferenceNameIdKey = "NAME";

  static Future<bool> saveTokenSharedPreference(String tokenKey) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(sharedPreferenceUserIdKey, tokenKey);
  }

  static Future<String?> getTokenSharedPreference() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(sharedPreferenceUserIdKey);
  }

  static Future<bool> removeTokenSharedPreference() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.remove(sharedPreferenceUserIdKey);
  }

//saving appartment id
  static Future<bool> saveIDAptSharedPreference(String aptid) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(sharedPreferenceApartmentIdKey, aptid);
  }

  static Future<String?> getIDAptSharedPreference() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(sharedPreferenceApartmentIdKey);
  }

//roles
  static Future<bool> saveRoleSharedPreference(String tokenKey) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(sharedPreferenceRoleIdKey, tokenKey);
  }

  static Future<String?> getRolesSharedPreference() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(sharedPreferenceRoleIdKey);
  }

  //name of user
  static Future<bool> saveNameSharedPreference(String tokenKey) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(sharedPreferenceRoleIdKey, tokenKey);
  }

  static Future<String?> getNameSharedPreference() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(sharedPreferenceRoleIdKey);
  }
}
