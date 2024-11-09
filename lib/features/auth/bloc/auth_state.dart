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

final class AuthOtpVerifySuccess extends AuthState {
  final String message;
  AuthOtpVerifySuccess({required this.message});
}

final class AuthOtpVerifyFailure extends AuthState {
  final String message;
  AuthOtpVerifyFailure({required this.message});
}



final class AuthUserFetchSuccess extends AuthState {
  final User user;

  AuthUserFetchSuccess({required this.user});
}
