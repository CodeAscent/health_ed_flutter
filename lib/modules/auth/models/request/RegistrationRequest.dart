class RegistrationRequest {
  final String fullName;

  final String email;
  final String dateOfBirth;
  final String languageSpokenAtHome;
  final String currentState;
  final bool isChildTakingSpeechTherapy;
  final String gender;

  RegistrationRequest({
    required this.fullName,
    required this.email,
    required this.dateOfBirth,
    required this.languageSpokenAtHome,
    required this.currentState,
    required this.isChildTakingSpeechTherapy,
    required this.gender,
  });

  Map<String, dynamic> toJson() {
    return {
      "fullName": fullName,
      "email": email,
      "dateOfBirth": dateOfBirth,
      "languageSpokenAtHome": languageSpokenAtHome,
      "currentState": currentState,
      "isChildTakingSpeechTherapy": isChildTakingSpeechTherapy,
      "gender": gender,
    };
  }
}
