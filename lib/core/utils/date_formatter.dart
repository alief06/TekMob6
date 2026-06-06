import 'package:intl/intl.dart';

class DateFormatter {
  static String format(String isoDateString) {
    try {
      final date = DateTime.parse(isoDateString);
      return DateFormat('dd MMM yyyy, HH:mm').format(date);
    } catch (e) {
      return isoDateString;
    }
  }
}
