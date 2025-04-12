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

class SubmitQuestionRequested extends AuthEvent {
  final SubmitQuestionRequest submitQuestionRequest;

  SubmitQuestionRequested({required this.submitQuestionRequest});
}

class CreatePaymentRequested extends AuthEvent {
  final CreatePayOrderReq createPayOrderReq;
  CreatePaymentRequested({required this.createPayOrderReq});
}
class CreateAssessPaymentRequested extends AuthEvent {
  CreateAssessPaymentRequested();
}

class VerifyPaymentRequested extends AuthEvent {
  final VerifyPayOrderReq verifyPayOrderReq;
  VerifyPaymentRequested({required this.verifyPayOrderReq});
}

class VerifyAssessPaymentRequested extends AuthEvent {
  final VerifyPayOrderReq verifyPayOrderReq;
  VerifyAssessPaymentRequested({required this.verifyPayOrderReq});
}




class AuthAssessmentQuestionDataRequested extends AuthEvent {}
class PlanDataRequested extends AuthEvent {}
class UserPlanDataRequested extends AuthEvent {}
