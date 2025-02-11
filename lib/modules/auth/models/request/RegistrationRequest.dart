class RegistrationRequest {
  final String fullName;
  final String familyType;
  final String email;
  final String dateOfBirth;
  final String fatherOccupation;
  final String motherOccupation;
  final int noOfSiblings;
  final String languageSpokenByChild;
  final String languageSpokenAtHome;
  final String currentCityDistrict;
  final String currentState;
  final bool isChildTakingSpeechTherapy;
  final String medium;
  final String gender;
  final String preferredLanguage;

  RegistrationRequest({
    required this.fullName,
    required this.familyType,
    required this.email,
    required this.dateOfBirth,
    required this.fatherOccupation,
    required this.motherOccupation,
    required this.noOfSiblings,
    required this.languageSpokenByChild,
    required this.languageSpokenAtHome,
    required this.currentCityDistrict,
    required this.currentState,
    required this.isChildTakingSpeechTherapy,
    required this.medium,
    required this.gender,
    required this.preferredLanguage,
  });

  Map<String, dynamic> toJson() {
    return {
      "fullName": fullName,
      "familyType": familyType,
      "email": email,
      "dateOfBirth": dateOfBirth,
      "fatherOccupation": fatherOccupation,
      "motherOccupation": motherOccupation,
      "noOfSiblings": noOfSiblings,
      "languageSpokenByChild": languageSpokenByChild,
      "languageSpokenAtHome": languageSpokenAtHome,
      "currentCityDistrict": currentCityDistrict,
      "currentState": currentState,
      "isChildTakingSpeechTherapy": isChildTakingSpeechTherapy,
      "medium": medium,
      "gender": gender,
      "preferredLanguage": preferredLanguage,
    };
  }
}
