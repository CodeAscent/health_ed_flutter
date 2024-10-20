// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

class AuthLoginRequested extends AuthEvent {
  final String email;
  final String password;

  AuthLoginRequested({required this.email, required this.password});
}

class AuthRegistrationRequested extends AuthEvent {
  final String email;
  final String password;
  final String fullName;
  final String gender;
  final String dob;

  AuthRegistrationRequested({
    required this.email,
    required this.password,
    required this.fullName,
    required this.gender,
    required this.dob,
  });
}

class AuthUserDataRequested extends AuthEvent {}
