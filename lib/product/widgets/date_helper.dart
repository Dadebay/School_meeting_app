import 'package:intl/intl.dart';

class DateHelper {
  static String getFormattedDate() {
    final now = DateTime.now();
    return DateFormat("MMMM d'th', y").format(now);
  }
}
