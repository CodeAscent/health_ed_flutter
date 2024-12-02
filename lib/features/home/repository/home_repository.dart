import 'dart:convert';

import 'package:health_ed_flutter/core/services/api_urls.dart';
import 'package:health_ed_flutter/core/services/http_wrapper.dart';
import 'package:health_ed_flutter/features/home/model/response/GetAllDaysResponse.dart';
import 'package:health_ed_flutter/features/home/model/response/ResActivityInstructions.dart';
import 'package:health_ed_flutter/features/home/model/response/ResAllActivity.dart';

class HomeRepository {
  Future<GetAllDaysResponse> getAllDays() async {
    try {
      final res = await HttpWrapper.getRequest(
        ApiUrls.all_days
      );
      final data = jsonDecode(res.body);
      if (res.statusCode == 200) {
        return GetAllDaysResponse.fromJson(data);
      } else {
        throw data['message'];
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<ResActivityInstructions> getActivityInstruction(String id) async {
    try {
      final res = await HttpWrapper.getRequest(
        '${ApiUrls.activity_instruction}/$id'
      );
      final data = jsonDecode(res.body);
      if (res.statusCode == 200) {
        return ResActivityInstructions.fromJson(data);
      } else {
        throw data['message'];
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<ResAllActivity> getAllActivity(String id) async {
    try {
      final res = await HttpWrapper.getRequest(
        '${ApiUrls.all_activity}/$id'
      );
      final data = jsonDecode(res.body);
      if (res.statusCode == 200) {
        return ResAllActivity.fromJson(data);
      } else {
        throw data['message'];
      }
    } catch (e) {
      rethrow;
    }
  }
}
