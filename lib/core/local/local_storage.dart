import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static late SharedPreferences prefs;

  static Future initialize() async {
    prefs = await SharedPreferences.getInstance();
  }

  static Future getString(key) async {
    return await prefs.getString(key);
  }

  static  Future<String?> getToken() async {
    final responseString = prefs.getString('userData');

    if (responseString != null) {
      final responseJson = jsonDecode(responseString);
      return responseJson['token']; // Access the token field
    }

    return null; // Return null if the response is not found
  }
}
