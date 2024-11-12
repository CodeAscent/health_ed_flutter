import 'package:flutter/cupertino.dart';

void unFocusAllFields(BuildContext context) {
  FocusScope.of(context).unfocus();
}

 String getRomanNumeral(int number) {
  const romanNumerals = ["i", "ii", "iii", "iv", "v", "vi", "vii", "viii", "ix", "x"];
  return romanNumerals[number % romanNumerals.length];
}
