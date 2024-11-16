import 'package:intl/intl.dart';

class DateFormatter {
  String formatDate(String value) {
    DateTime dateTime = DateFormat("yyyy-MM-ddTHH:mm:ss.SSSZ").parse(value);
    String formatted = DateFormat('d MMM yyyy', 'id_ID').format(dateTime);
    return formatted;
  }
}
