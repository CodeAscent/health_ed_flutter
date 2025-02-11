import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/local/local_storage.dart';

class ProfileState {
  final String sId;
  final String name;
  final String phoneNumber;
  final String email;
  final bool isPhoneValid;
  final bool isEmailValid;

  ProfileState({
    required this.sId,
    required this.name,
    required this.phoneNumber,
    required this.email,
    this.isPhoneValid = false,
    this.isEmailValid = false,
  });

  ProfileState copyWith({
    String? sId,
    String? name,
    String? phoneNumber,
    String? email,
    bool? isPhoneValid,
    bool? isEmailValid,
  }) {
    return ProfileState(
      sId: sId ?? this.sId,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      isPhoneValid: isPhoneValid ?? this.isPhoneValid,
      isEmailValid: isEmailValid ?? this.isEmailValid,
    );
  }
}


class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileState(sId: '', name: '', phoneNumber: '', email: ''));

  Future<void> loadUserData() async {
    final userData = await LocalStorage.getUserData();

    if (userData != null) {
      emit(state.copyWith(
        sId: userData.user!.sId ?? '',
        name: userData.user!.fullName ?? '',
        phoneNumber: userData.user!.mobile ?? '',
        email: userData.user!.email ?? '',
        isPhoneValid: validatePhone(userData.user!.mobile ?? ''),
        isEmailValid: validateEmail(userData.user!.email ?? ''),
      ));
    }
  }

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

