import 'package:flutter/material.dart';

class ColorPallete {
  static const Color primary = Color(0xff133088);
  static const Color secondary = Color(0xff000030);
  static const Color disabled = Color.fromARGB(255, 186, 182, 182);
  static const Color whiteShade = Color(0xffF4F5FD);
  static const Color ceruleanBlue = Color(0xff133088);
  static const Color navyBlue = Color(0xff000030);

  static LinearGradient gradient = LinearGradient(colors: [primary, secondary]);
}
