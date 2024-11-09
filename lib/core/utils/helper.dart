import 'package:flutter/cupertino.dart';

void unFocusAllFields(BuildContext context) {
  FocusScope.of(context).unfocus();
}
