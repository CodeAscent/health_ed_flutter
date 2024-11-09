// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

class AuthLoginRequested extends AuthEvent {
  final LoginRequest loginRequest;
  AuthLoginRequested({required this.loginRequest});
}

class AuthOtpVerifyRequested extends AuthEvent {
  final OtpVerifyRequest otpVerifyRequest;
  AuthOtpVerifyRequested({required this.otpVerifyRequest});
}

class AuthRegistrationRequested extends AuthEvent {
  final RegistrationRequest registrationRequest;

  AuthRegistrationRequested(this.registrationRequest);
}




class AuthUserDataRequested extends AuthEvent {}
