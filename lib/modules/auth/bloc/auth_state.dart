part of 'auth_bloc.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class AuthLoginSuccess extends AuthState {
  final String message;
  AuthLoginSuccess({required this.message});
}

final class AuthRegisterSuccess extends AuthState {
  final String message;
  AuthRegisterSuccess({required this.message});
}

final class AuthFailure extends AuthState {
  final String message;
  AuthFailure({required this.message});
}

final class VerifyOrderFailure extends AuthState {
  final String message;
  VerifyOrderFailure({required this.message});
}

final class AuthOtpVerifySuccess extends AuthState {
  final OtpVerifyResponse otpVerifyResponse;
  AuthOtpVerifySuccess({required this.otpVerifyResponse});
}

final class AuthSubmitQuestionSuccess extends AuthState {
  final SubmitQuestionResponse submitQuestionResponse;
  AuthSubmitQuestionSuccess({required this.submitQuestionResponse});
}

final class AuthAssessmentQuestionSuccess extends AuthState {
  final AssessmentQuestionResponse assessmentQuestionResponse;
  AuthAssessmentQuestionSuccess({required this.assessmentQuestionResponse});
}

final class AuthPlanSuccess extends AuthState {
  final AllPlanResponse allPlanResponse;
  AuthPlanSuccess({required this.allPlanResponse});
}

final class AuthPlanFailure extends AuthState {
  final String message;
  AuthPlanFailure({required this.message});
}

final class AuthOtpVerifyFailure extends AuthState {
  final String message;
  AuthOtpVerifyFailure({required this.message});
}

final class CreatePaymentOrderSuccess extends AuthState {
  final ResCreateOrder resCreateOrder;
  CreatePaymentOrderSuccess({required this.resCreateOrder});
}

final class CreateAssessPaymentOrderSuccess extends AuthState {
  final ResAssesmentCreateOrder resAssesmentCreateOrder;
  CreateAssessPaymentOrderSuccess({required this.resAssesmentCreateOrder});
}

final class VerifyPaymentOrderSuccess extends AuthState {
  final ResVerifyOrder resVerifyOrder;
  VerifyPaymentOrderSuccess({required this.resVerifyOrder});
}



