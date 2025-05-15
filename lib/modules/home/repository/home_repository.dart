import 'dart:convert';

import 'package:health_ed_flutter/core/services/api_urls.dart';
import 'package:health_ed_flutter/core/services/http_wrapper.dart';
import 'package:health_ed_flutter/modules/home/model/request/AcknowledgementRequest.dart';
import 'package:health_ed_flutter/modules/home/model/request/ReportRequest.dart';
import 'package:health_ed_flutter/modules/home/model/response/GetAllDaysResponse.dart';
import 'package:health_ed_flutter/modules/home/model/response/ReportResponse.dart';
import 'package:health_ed_flutter/modules/home/model/response/ResActivityInstructions.dart';
import 'package:health_ed_flutter/modules/home/model/response/ResAllActivity.dart';
import 'package:health_ed_flutter/modules/home/model/response/ResAllQuestion.dart';
import 'package:health_ed_flutter/modules/home/model/response/ResUserAcknowledgement.dart';

class HomeRepository {
  Future<GetAllDaysResponse> getAllDays() async {
    try {
      final res = await HttpWrapper.getRequest(ApiUrls.all_days);
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
      final res =
          await HttpWrapper.getRequest('${ApiUrls.activity_instruction}/$id');
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
      final res = await HttpWrapper.getRequest('${ApiUrls.all_activity}/$id');
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

  Future<ResAllQuestion> getAllQuestion(String id) async {
    try {
      final res = await HttpWrapper.getRequest('${ApiUrls.all_question}/$id');
      final data = jsonDecode(res.body);
      if (res.statusCode == 200) {
        return ResAllQuestion.fromJson(data);
      } else {
        throw data['message'];
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<ResUserAcknowledgement> submitAcknowledgement(
      AcknowledgementRequest acknowledgementRequest) async {
    try {
      final res = await HttpWrapper.postRequest(
        ApiUrls.user_acknowledgement,
        acknowledgementRequest.toJson(),
      );
      final data = jsonDecode(res.body);
      if (res.statusCode == 200) {
        return ResUserAcknowledgement.fromJson(data);
      } else {
        throw data['message'];
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<ReportResponse> getReport(ReportRequest reportRequest) async {
    try {
      final res = await HttpWrapper.postRequest(
        ApiUrls.user_report_html,
        reportRequest.toJson(),
        isByteResponse: true,
      );

      if (res.statusCode == 200) {
        return ReportResponse.fromPdfBytes(res.bodyBytes);
      } else {
        final errorData = jsonDecode(utf8.decode(res.bodyBytes));
        throw errorData['message'] ?? 'Unknown error';
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<ReportResponse> getInvoice() async {
    try {
      final res = await HttpWrapper.getRequest(
        ApiUrls.user_report_pdf,
        isByteResponse: true,
      );

      if (res.statusCode == 200) {
        return ReportResponse.fromPdfBytes(
            res.bodyBytes); // note: use bodyBytes
      } else {
        final errorData = jsonDecode(utf8.decode(res.bodyBytes));
        throw errorData['message'] ?? 'Unknown error';
      }
    } catch (e) {
      rethrow;
    }
  }
}
