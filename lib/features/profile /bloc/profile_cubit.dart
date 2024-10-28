import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileState {
  final String name;
  final String phoneNumber;
  final String email;
  final bool isPhoneValid;
  final bool isEmailValid;

  ProfileState({
    required this.name,
    required this.phoneNumber,
    required this.email,
    this.isPhoneValid = false,
    this.isEmailValid = false,
  });

  ProfileState copyWith({
    String? name,
    String? phoneNumber,
    String? email,
    bool? isPhoneValid,
    bool? isEmailValid,
  }) {
    return ProfileState(
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      isPhoneValid: isPhoneValid ?? this.isPhoneValid,
      isEmailValid: isEmailValid ?? this.isEmailValid,
    );
  }
}

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit()
      : super(ProfileState(
    name: 'John Medison',
    phoneNumber: '+91 7056634258',
    email: 'john@gmail.com',
  ));

  void updateName(String name) => emit(state.copyWith(name: name));
  void updatePhoneNumber(String phone) =>
      emit(state.copyWith(phoneNumber: phone, isPhoneValid: validatePhone(phone)));
  void updateEmail(String email) =>
      emit(state.copyWith(email: email, isEmailValid: validateEmail(email)));

  bool validatePhone(String phone) {
    // Basic validation logic here
    return phone.isNotEmpty;
  }

  bool validateEmail(String email) {
    // Basic validation logic here
    return email.contains('@');
  }
}
