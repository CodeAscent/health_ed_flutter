import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static late SharedPreferences prefs;

  static Future initialize() async {
    prefs = await SharedPreferences.getInstance();
  }

  static Future getString(key) async {
    return await prefs.getString(key);
  }
}
