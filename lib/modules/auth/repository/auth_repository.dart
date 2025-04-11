import 'dart:convert';

import 'package:health_ed_flutter/core/local/local_storage.dart';
import 'package:health_ed_flutter/core/services/api_urls.dart';
import 'package:health_ed_flutter/core/services/http_wrapper.dart';
import 'package:health_ed_flutter/modules/auth/models/request/CreatePayOrderReq.dart';
import 'package:health_ed_flutter/modules/auth/models/response/ResAssesmentCreateOrder.dart';
import 'package:health_ed_flutter/modules/auth/models/request/VerifyPayOrderReq.dart';
import 'package:health_ed_flutter/modules/auth/models/request/LoginRequest.dart';
import 'package:health_ed_flutter/modules/auth/models/request/OtpVerifyRequest.dart';
import 'package:health_ed_flutter/modules/auth/models/request/SubmitQuestionRequest.dart';
import 'package:health_ed_flutter/modules/auth/models/response/AllPlanResponse.dart';
import 'package:health_ed_flutter/modules/auth/models/response/AssessmentQuestionResponse.dart';
import 'package:health_ed_flutter/modules/auth/models/response/OtpVerifyResponse.dart';
import 'package:health_ed_flutter/modules/auth/models/response/ResCreateOrder.dart';
import 'package:health_ed_flutter/modules/auth/models/response/ResVerifyOrder.dart';
import 'package:health_ed_flutter/modules/auth/models/response/SubmitQuestionResponse.dart';
import 'package:logger/logger.dart';

import '../models/request/RegistrationRequest.dart';
import '../models/response/LoginResponse.dart';
import '../models/response/RegisterResponse.dart';
import '../models/response/StateResponse.dart';
import '../models/response/CityResponse.dart';

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
      final res = await HttpWrapper.getRequest(ApiUrls.onboarding_questions);
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

    Future<AllPlanResponse> getAllPlan() async {
    try {
      final res = await HttpWrapper.getRequest(ApiUrls.subscription_plans);
      final data = jsonDecode(res.body);
      if (res.statusCode == 200) {
        return AllPlanResponse.fromJson(data);
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
        await LocalStorage.prefs.setString('user', jsonEncode(data['user']));
        return data;
      } else {
        throw data['message'];
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<StateResponse> getAllStates() async {
    try {
      final response = await HttpWrapper.getRequest(ApiUrls.get_all_states);
      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return StateResponse.fromJson(data);
      } else {
        throw data['message'];
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<CityResponse> getCitiesByStateId(int stateId) async {
    try {
      final response =
          await HttpWrapper.getRequest(ApiUrls.get_all_cities + '/$stateId');
      Logger().d(response.body);

      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return CityResponse.fromJson(data);
      } else {
        throw data['message'];
      }
    } catch (e) {
      rethrow;
    }
  }

   Future<ResCreateOrder> createPayment(CreatePayOrderReq createPayment) async {
    try {
      final res = await HttpWrapper.postRequest(
        ApiUrls.create_subscription_plans,
        createPayment.toJson(),
      );
      final data = jsonDecode(res.body);
      if (res.statusCode == 200) {
        return ResCreateOrder.fromJson(data);
      } else {
        throw data['message'];
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<ResAssesmentCreateOrder> createAssessPayOrder() async {
    try {
      final res = await HttpWrapper.postRequest(
        ApiUrls.assessment_payment_create_order,null
      );
      final data = jsonDecode(res.body);
      if (res.statusCode == 200) {
        return ResAssesmentCreateOrder.fromJson(data);
      } else {
        throw data['message'];
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<ResVerifyOrder> verifyPayOrder(VerifyPayOrderReq verifyPayOrderReq) async {
    try {
      final res = await HttpWrapper.postRequest(
        ApiUrls.subscription_payment_verify,
        verifyPayOrderReq.toJson(),
      );
      final data = jsonDecode(res.body);
      if (res.statusCode == 200) {
        return ResVerifyOrder.fromJson(data);
      } else {
        throw data['message'];
      }
    } catch (e) {
      rethrow;
    }
  }

    Future<ResVerifyOrder> verifyAssessPayOrder(VerifyPayOrderReq verifyPayOrderReq) async {
    try {
      final res = await HttpWrapper.postRequest(
        ApiUrls.assessment_payment_verify,
        verifyPayOrderReq.toJson(),
      );
      final data = jsonDecode(res.body);
      if (res.statusCode == 200) {
        return ResVerifyOrder.fromJson(data);
      } else {
        throw data['message'];
      }
    } catch (e) {
      rethrow;
    }
  }
}
