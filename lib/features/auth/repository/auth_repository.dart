import 'dart:convert';

import 'package:health_ed_flutter/core/services/api_urls.dart';
import 'package:health_ed_flutter/core/services/http_wrapper.dart';

class AuthRepository {
  Future login({required String email, required String password}) async {
    try {
      final body = {
        "email": email,
        "password": password,
      };
      final res = await HttpWrapper.postRequest(ApiUrls.login, body);
      final data = jsonDecode(res.body);
      if (res.statusCode == 200) {
        return data;
      } else {
        throw data['message'];
      }
    } catch (e) {
      rethrow;
    }
  }

  Future signUp(
      {required String email,
      required String password,
      required String fullName,
      required String gender,
      required String dob}) async {
    try {
      final body = {
        "email": email,
        "password": password,
        "fullName": fullName,
        "dateOfBirth": dob,
        "gender": gender,
      };
      final res = await HttpWrapper.postRequest(ApiUrls.register, body);
      final data = jsonDecode(res.body);
      if (res.statusCode == 200) {
        return data;
      } else {
        throw data['message'];
      }
    } catch (e) {
      rethrow;
    }
  }

  Future fetchUser() async {
    try {
      final res = await HttpWrapper.getRequest(ApiUrls.get_user);
      final data = jsonDecode(res.body);
      if (res.statusCode == 200) {
        return data;
      } else {
        throw data['message'];
      }
    } catch (e) {
      rethrow;
    }
  }
}
