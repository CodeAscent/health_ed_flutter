import 'dart:convert';
import 'dart:ffi';

import 'package:bloc/bloc.dart';
import 'package:health_ed_flutter/core/local/local_storage.dart';
import 'package:health_ed_flutter/features/auth/models/request/LoginRequest.dart';
import 'package:health_ed_flutter/features/auth/models/request/OtpVerifyRequest.dart';
import 'package:health_ed_flutter/features/auth/models/user.dart';
import 'package:health_ed_flutter/features/auth/repository/auth_repository.dart';
import 'package:meta/meta.dart';

import '../models/request/RegistrationRequest.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;
  AuthBloc(this.authRepository) : super(AuthInitial()) {
    on<AuthLoginRequested>(authLogin);
    on<AuthOtpVerifyRequested>(verifyOtp);
    on<AuthUserDataRequested>(authUser);
    on<AuthRegistrationRequested>(authRegister);
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
      // await LocalStorage.prefs.setString('token', res['token']);
      emit(AuthLoginSuccess(message: res.message!));
    } catch (e) {
      emit(AuthFailure(message: e.toString()));
    }
  }

  Future<void> authUser(
      AuthUserDataRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final res = await authRepository.fetchUser();
      final user = User.fromMap(res['user']);
      emit(AuthUserFetchSuccess(user: user));
    } catch (e) {
      emit(AuthFailure(message: e.toString()));
    }
  }
}
