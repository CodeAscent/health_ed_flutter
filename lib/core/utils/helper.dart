import 'package:flutter/cupertino.dart';

void unFocusAllFields(BuildContext context) {
  FocusScope.of(context).unfocus();
}

 String getRomanNumeral(int number) {
  const romanNumerals = ["i", "ii", "iii", "iv", "v", "vi", "vii", "viii", "ix", "x"];
  return romanNumerals[number % romanNumerals.length];
}

String getLanguageCode(String language,String languageCode) {
  switch (language) {
    case 'Hindi':
      languageCode = "hi-IN";
      return "hi";
    case 'Odia':
      languageCode = "or-IN";
      return "or";
    default:
      languageCode = "en-US";
      return "en";
  }
}

