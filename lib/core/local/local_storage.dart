import 'dart:convert';

import 'package:health_ed_flutter/modules/auth/models/response/OtpVerifyResponse.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static late SharedPreferences prefs;

  static Future initialize() async {
    prefs = await SharedPreferences.getInstance();
  }
  static Future<void> removeUserData() async {
    await prefs.remove('userData');
  }

  static Future getString(key) async {
    return await prefs.getString(key);
  }

  static  Future<String?> getToken() async {
    final responseString = prefs.getString('userData');

    if (responseString != null) {
      final responseJson = jsonDecode(responseString);
      return responseJson['token'];
    }
    return null;
  }

  static Future<Data?> getUserData() async {
    final responseString = prefs.getString('userProfileData');
    if (responseString != null) {
      // Parse JSON string to a Map
      final Map<String, dynamic> jsonData = jsonDecode(responseString);

      // Convert the Map to a Data model instance
      final data = Data.fromJson(jsonData);

      return data;
    }
    return null;
  }

}
