import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/local/local_storage.dart';

class ProfileState {
  final String sId;
  final String name;
  final String phoneNumber;
  final String email;
  final String gender;
  final String dateOfBirth;
  final String languageSpokenAtHome;
  final String speechOutput;
  final String nonSpeechOutput;
  final bool isChildTakingSpeechTherapy;
  final bool isPhoneValid;
  final bool isEmailValid;

  ProfileState({
    required this.sId,
    required this.name,
    required this.phoneNumber,
    required this.email,
    required this.gender,
    required this.dateOfBirth,
    required this.languageSpokenAtHome,
    required this.speechOutput,
    required this.nonSpeechOutput,
    required this.isChildTakingSpeechTherapy,
    this.isPhoneValid = false,
    this.isEmailValid = false,
  });

  ProfileState copyWith({
    String? sId,
    String? name,
    String? phoneNumber,
    String? email,
    String? gender,
    String? dateOfBirth,
    String? languageSpokenAtHome,
    String? speechOutput,
    String? nonSpeechOutput,
    bool? isPhoneValid,
    bool? isEmailValid,
  }) {
    return ProfileState(
      sId: sId ?? this.sId,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      gender: gender ?? this.gender,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      languageSpokenAtHome: languageSpokenAtHome ?? this.languageSpokenAtHome,
      speechOutput: speechOutput ?? this.speechOutput,
      nonSpeechOutput: nonSpeechOutput ?? this.nonSpeechOutput,
      isChildTakingSpeechTherapy:
          isChildTakingSpeechTherapy ?? this.isChildTakingSpeechTherapy,
      isPhoneValid: isPhoneValid ?? this.isPhoneValid,
      isEmailValid: isEmailValid ?? this.isEmailValid,
    );
  }
}

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit()
      : super(ProfileState(
          sId: '',
          name: '',
          phoneNumber: '',
          email: '',
          gender: '',
          dateOfBirth: '',
          languageSpokenAtHome: '',
          speechOutput: '',
          nonSpeechOutput: '',
          isChildTakingSpeechTherapy: false,
          isPhoneValid: false,
          isEmailValid: false,
        ));

  Future<void> loadUserData() async {
    final userData = await LocalStorage.getUserData();
    print('User data loaded: ${userData?.user?.fullName}');
    if (userData != null) {
      emit(state.copyWith(
        sId: userData.user!.sId ?? '',
        name: userData.user!.fullName ?? '',
        phoneNumber: userData.user!.mobile ?? '',
        email: userData.user!.email ?? '',
        gender: userData.user!.gender ?? '',
        dateOfBirth: userData.user!.dateOfBirth ?? '',
        languageSpokenAtHome: userData.user!.languageSpokenAtHome ?? '',
        isPhoneValid: validatePhone(userData.user!.mobile ?? ''),
        isEmailValid: validateEmail(userData.user!.email ?? ''),
      ));
    }
  }

  void updateName(String name) => emit(state.copyWith(name: name));
  void updatePhoneNumber(String phone) => emit(
      state.copyWith(phoneNumber: phone, isPhoneValid: validatePhone(phone)));
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
