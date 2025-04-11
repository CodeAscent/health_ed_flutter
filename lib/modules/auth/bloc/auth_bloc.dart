import 'dart:convert';
import 'dart:ffi';

import 'package:bloc/bloc.dart';
import 'package:health_ed_flutter/core/local/local_storage.dart';
import 'package:health_ed_flutter/modules/auth/models/request/CreatePayOrderReq.dart';
import 'package:health_ed_flutter/modules/auth/models/response/ResAssesmentCreateOrder.dart';
import 'package:health_ed_flutter/modules/auth/models/request/VerifyPayOrderReq.dart';
import 'package:health_ed_flutter/modules/auth/models/request/LoginRequest.dart';
import 'package:health_ed_flutter/modules/auth/models/request/OtpVerifyRequest.dart';
import 'package:health_ed_flutter/modules/auth/models/response/AllPlanResponse.dart';
import 'package:health_ed_flutter/modules/auth/models/response/AssessmentQuestionResponse.dart';
import 'package:health_ed_flutter/modules/auth/models/response/OtpVerifyResponse.dart';
import 'package:health_ed_flutter/modules/auth/models/response/ResCreateOrder.dart';
import 'package:health_ed_flutter/modules/auth/models/response/ResVerifyOrder.dart';
import 'package:health_ed_flutter/modules/auth/models/response/SubmitQuestionResponse.dart';
import 'package:health_ed_flutter/modules/auth/models/user.dart';
import 'package:health_ed_flutter/modules/auth/repository/auth_repository.dart';
import 'package:meta/meta.dart';

import '../models/request/RegistrationRequest.dart';
import '../models/request/SubmitQuestionRequest.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;
  AuthBloc(this.authRepository) : super(AuthInitial()) {
    on<AuthLoginRequested>(authLogin);
    on<AuthOtpVerifyRequested>(verifyOtp);
    on<AuthRegistrationRequested>(authRegister);
    on<SubmitQuestionRequested>(submitAnswer);
    on<AuthAssessmentQuestionDataRequested>(getAssessmentQuestion);
    on<PlanDataRequested>(getAllPlan);
    on<CreatePaymentRequested>(createPayOrder);
    on<VerifyPaymentRequested>(verifyPayOrder);
    on<VerifyAssessPaymentRequested>(verifyAssessPayOrder);
    on<CreateAssessPaymentRequested>(createAssessPayOrder);
  }
  Future<void> authRegister(
      AuthRegistrationRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final res = await authRepository.signUp(event.registrationRequest);
      emit(AuthRegisterSuccess(message: res.message));
    } catch (e) {
      emit(AuthFailure(message: e.toString()));
    }
  }

  Future<void> authLogin(
      AuthLoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final res = await authRepository.login(event.loginRequest);
      // final user = User.fromMap(res['user']);
      // await LocalStorage.prefs.setString('token', res['token']);
      emit(AuthLoginSuccess(message: res.message+"\nOtp Is ${res.data.otp.toString()}"));
    } catch (e) {
      emit(AuthFailure(message: e.toString()));
    }
  }

  Future<void> verifyOtp(
      AuthOtpVerifyRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final res = await authRepository.verifyOtp(event.otpVerifyRequest);
      // final user = User.fromMap(res['user']);
      await LocalStorage.prefs.setString('userData', jsonEncode(res.data));;
      emit(AuthOtpVerifySuccess(otpVerifyResponse: res));
    } catch (e) {
      emit(AuthFailure(message: e.toString()));
    }
  }

  Future<void> getAssessmentQuestion(
      AuthAssessmentQuestionDataRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final res = await authRepository.getAssessmentQuestion();
      emit(AuthAssessmentQuestionSuccess(assessmentQuestionResponse: res));
    } catch (e) {
      emit(AuthFailure(message: e.toString()));
    }
  }

    Future<void> getAllPlan(
      PlanDataRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final res = await authRepository.getAllPlan();
      emit(AuthPlanSuccess(allPlanResponse: res));
    } catch (e) {
      emit(AuthPlanFailure(message: e.toString()));
    }
  }

  Future<void> submitAnswer(
      SubmitQuestionRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final res = await authRepository.submitAnswer(event.submitQuestionRequest);
      emit(AuthSubmitQuestionSuccess(submitQuestionResponse:res));
    } catch (e) {
      emit(AuthFailure(message: e.toString()));
    }
  }

   Future<void> createPayOrder(
      CreatePaymentRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final res = await authRepository.createPayment(event.createPayOrderReq);
      // final user = User.fromMap(res['user']);
      // await LocalStorage.prefs.setString('token', res['token']);
      emit(CreatePaymentOrderSuccess(resCreateOrder: res));
    } catch (e) {
      emit(AuthFailure(message: e.toString()));
    }
  }

   Future<void> createAssessPayOrder(
      CreateAssessPaymentRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final res = await authRepository.createAssessPayOrder();
      // final user = User.fromMap(res['user']);
      // await LocalStorage.prefs.setString('token', res['token']);
      emit(CreateAssessPaymentOrderSuccess(resAssesmentCreateOrder: res));
    } catch (e) {
      emit(AuthFailure(message: e.toString()));
    }
  }

  //  Future<void> createAssessPayOrder(
  //     CreatePayOrderReq event, Emitter<AuthState> emit) async {
  //   emit(AuthLoading());
  //   try {
  //     final res = await authRepository.createAssessPayOrder();
  //     // final user = User.fromMap(res['user']);
  //     // await LocalStorage.prefs.setString('token', res['token']);
  //     emit(CreateAssessPaymentOrderSuccess(resAssesmentCreateOrder: res));
  //   } catch (e) {
  //     emit(AuthFailure(message: e.toString()));
  //   }
  // }

     Future<void> verifyPayOrder(
      VerifyPaymentRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final res = await authRepository.verifyPayOrder(event.verifyPayOrderReq);
      // final user = User.fromMap(res['user']);
      // await LocalStorage.prefs.setString('token', res['token']);
      emit(VerifyPaymentOrderSuccess(resVerifyOrder: res));
    } catch (e) {
      emit(VerifyOrderFailure(message: e.toString()));
    }
  }

      Future<void> verifyAssessPayOrder(
      VerifyAssessPaymentRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final res = await authRepository.verifyAssessPayOrder(event.verifyPayOrderReq);
      // final user = User.fromMap(res['user']);
      // await LocalStorage.prefs.setString('token', res['token']);
      emit(VerifyPaymentOrderSuccess(resVerifyOrder: res));
    } catch (e) {
      emit(VerifyOrderFailure(message: e.toString()));
    }
  }




}
