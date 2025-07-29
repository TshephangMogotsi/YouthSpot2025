import 'package:intl/intl.dart';

class Utils {
  static String toDateTime(DateTime dateTime) {
    final date = DateFormat.yMMMEd().format(dateTime);
    final time = DateFormat.Hm().format(dateTime);

    return '$date $time';
  }

  static String toDate(DateTime dateTime) {
    final date = DateFormat.yMMMEd().format(dateTime);
    return date;
  }

  static String toTime(DateTime dateTime) {
    final time = DateFormat.Hm().format(dateTime);
    return time;
  }
}

class NotificationUtils {
  static String formatEventTime(DateTime from, DateTime to) {
    final sameDay = from.year == to.year &&
        from.month == to.month &&
        from.day == to.day;

    if (sameDay) {
      final fromTime = DateFormat('h:mm a').format(from);
      final toTime = DateFormat('h:mm a').format(to);
      return "$fromTime - $toTime";
    } else {
      final fromDate = DateFormat('MMM dd').format(from);
      final fromTime = DateFormat('h:mm a').format(from);
      final toDate = DateFormat('MMM dd').format(to);
      final toTime = DateFormat('h:mm a').format(to);
      return "$fromDate, $fromTime - $toDate, $toTime";
    }
  }
}
