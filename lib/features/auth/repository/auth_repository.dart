import 'dart:convert';

import 'package:health_ed_flutter/core/services/api_urls.dart';
import 'package:health_ed_flutter/core/services/http_wrapper.dart';
import 'package:health_ed_flutter/features/auth/models/request/LoginRequest.dart';
import 'package:health_ed_flutter/features/auth/models/request/OtpVerifyRequest.dart';
import 'package:health_ed_flutter/features/auth/models/request/SubmitQuestionRequest.dart';
import 'package:health_ed_flutter/features/auth/models/response/AssessmentQuestionResponse.dart';
import 'package:health_ed_flutter/features/auth/models/response/OtpVerifyResponse.dart';
import 'package:health_ed_flutter/features/auth/models/response/SubmitQuestionResponse.dart';
import 'package:logger/logger.dart';

import '../models/request/RegistrationRequest.dart';
import '../models/response/LoginResponse.dart';
import '../models/response/RegisterResponse.dart';

class AuthRepository {
  Future<LoginResponse> login(LoginRequest loginRequest) async {
    try {
      final res = await HttpWrapper.postRequest(
        ApiUrls.login,
        loginRequest.toJson(),
      );
      final data = jsonDecode(res.body);
      if (res.statusCode == 200) {
        return LoginResponse.fromJson(data);
      } else {
        throw data['message'];
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<OtpVerifyResponse> verifyOtp(OtpVerifyRequest otpVerifyRequest) async {
    try {
      final res = await HttpWrapper.postRequest(
        ApiUrls.verifyOtp,
        otpVerifyRequest.toJson(),
      );
      final data = jsonDecode(res.body);
      if (res.statusCode == 200) {
        return OtpVerifyResponse.fromJson(data);
      } else {
        throw data['message'];
      }
    } catch (e) {
      rethrow;
    }
  }
  Future<AssessmentQuestionResponse> getAssessmentQuestion() async {
    try {
      final res = await HttpWrapper.getRequest(
        ApiUrls.onboarding_questions
      );
      final data = jsonDecode(res.body);
      if (res.statusCode == 200) {
        return AssessmentQuestionResponse.fromJson(data);
      } else {
        throw data['message'];
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<RegisterResponse> signUp(
      RegistrationRequest registrationRequest) async {
    try {
      final res = await HttpWrapper.postRequest(
        ApiUrls.register,
        registrationRequest.toJson(),
      );
      final data = jsonDecode(res.body);
      if (res.statusCode == 200) {
        return RegisterResponse.fromJson(data);
      } else {
        throw data['message'];
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<SubmitQuestionResponse> submitAnswer(
      SubmitQuestionRequest submitQuestionRequest) async {
    try {
      final res = await HttpWrapper.postRequest(
        ApiUrls.submit_onboarding_questions,
        submitQuestionRequest.toJson(),
      );
      final data = jsonDecode(res.body);
      if (res.statusCode == 200) {
        return SubmitQuestionResponse.fromJson(data);
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
