import 'package:flutter/material.dart';

class ColorPallete {
  static const Color primary = Color(0xff133088);
  static const Color secondary = Color(0xff000030);
  static const Color disabled = Color.fromARGB(255, 186, 182, 182);
  static const Color whiteShade = Color(0xffF4F5FD);
  static const Color greyShade = Color(0xffC6C6C6);
  static const Color greyShade1 = Color(0xffE6E6E6);
  static const Color greyColor = Color(0xff808080);
  static const Color greenShade = Color(0xff1CED51);
  static const Color greenColor = Color(0xff34C759);
  static const Color ceruleanBlue = Color(0xff133088);
  static const Color navyBlue = Color(0xff000030);
  static const Color grayBlue = Color(0x1F133088);

  static LinearGradient gradient = LinearGradient(colors: [primary, secondary]);
  static LinearGradient gradientWhite = LinearGradient(colors: [whiteShade, whiteShade]);
}
