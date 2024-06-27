import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<bool> isMobileDevice() async {
  if (kIsWeb) {
    return false;
  } else if (Platform.isAndroid || Platform.isIOS) {
    return true;
  } else {
    return false;
  }
}

Future<void> saveIsMobileToSharedPreferences(bool isMobile) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool('isMobile', isMobile);
}

Future<bool?> getIsMobileFromSharedPreferences() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool('isMobile');
}
