import 'dart:convert';
import 'package:health_ed_flutter/core/config/app_config.dart';
import 'package:health_ed_flutter/core/local/local_storage.dart';
import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;

class HttpWrapper {
  static final _logger = Logger();

  static Future<Map<String, String>> headers() async {
    String? token = await LocalStorage.getToken();
    Logger().f(token);
    return {
      'content-type': "application/json",
      if (token != null) "Authorization": "Bearer $token",
    };
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

      return res;
    } catch (e) {
      _logger.e("GET Request Error: $e");
      rethrow;
    }
  }

  /// POST request
  static Future<http.Response> postRequest(
      String endpoint, dynamic payload,) async {
    try {
      final url = AppConfig.base_url + endpoint;
      final requestHeaders = await headers();
      final body = jsonEncode(payload);

      _logger.i("POST Request URL: $url");
      _logger.i("POST Request Headers: $requestHeaders");
      _logger.i("POST Request Body: $body");

      final res =
          await http.post(Uri.parse(url), body: body, headers: requestHeaders);

      _logger.i("POST Response Status: ${res.statusCode}");
      _logger.i("POST Response Body: ${res.body}");

      return res;
    } catch (e) {
      _logger.e("POST Request Error: $e");
      rethrow;
    }
  }
}
