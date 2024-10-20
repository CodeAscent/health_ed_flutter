import 'package:intl/intl.dart';

customDateFormat(String date) {
  return DateFormat('dd/MM/yyyy').format(DateTime.parse(date).toLocal());
}
