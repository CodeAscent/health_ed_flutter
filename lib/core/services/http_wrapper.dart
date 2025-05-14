import 'dart:convert';
import 'package:health_ed_flutter/core/config/app_config.dart';
import 'package:health_ed_flutter/core/local/local_storage.dart';
import 'package:get/get.dart'; // <-- Required for Get.offAll
import 'package:health_ed_flutter/modules/auth/views/screens/login_screen.dart';
import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;

class HttpWrapper {
  static final _logger = Logger();

  static Future<Map<String, String>> headers() async {
    String? token = await LocalStorage.getToken();
    Logger().f(token);
    return {
      'content-type': "application/json",
      "Authorization": "Bearer $token",
    };
  }

  /// Common method to check and handle 401 Unauthorized
  static void _handleUnauthorized(http.Response res) async {
    if (res.statusCode == 401) {
      _logger.w("Unauthorized! Logging out user.");
      await LocalStorage.removeUserData(); // Clear local storage
      Get.offAll(() => LoginScreen()); // Navigate to Login screen
    }
  }

  /// GET request
  static Future<http.Response> getRequest(String endpoint) async {
    try {
      final url = AppConfig.base_url + endpoint;
      final requestHeaders = await headers();

      _logger.i("GET Request URL: $url");
      _logger.i("GET Request Headers: $requestHeaders");

      final res = await http.get(Uri.parse(url), headers: requestHeaders);

      _logger.i("GET Response Status: ${res.statusCode}");
      _logger.i("GET Response Body: ${res.body}");

      _handleUnauthorized(res); // 👈 check for 401

      return res;
    } catch (e) {
      _logger.e("GET Request Error: $e");
      rethrow;
    }
  }

  /// POST request
  static Future<http.Response> postRequest(
      String endpoint, dynamic payload) async {
    try {
      final url = AppConfig.base_url + endpoint;
      final requestHeaders = await headers();

      _logger.i("POST Request URL: $url");
      _logger.i("POST Request Headers: $requestHeaders");

      http.Response res;

      if (payload != null) {
        final body = jsonEncode(payload);
        _logger.i("POST Request Body: $body");

        res = await http.post(
          Uri.parse(url),
          body: body,
          headers: requestHeaders,
        );
      } else {
        res = await http.post(
          Uri.parse(url),
          headers: requestHeaders,
        );
      }

      _logger.i("POST Response Status: ${res.statusCode}");
      _logger.i("POST Response Body: ${res.body}");

      _handleUnauthorized(res); // 👈 check for 401

      return res;
    } catch (e) {
      _logger.e("POST Request Error: $e");
      rethrow;
    }
  }
}
