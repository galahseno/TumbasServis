import 'package:intl/intl.dart';

abstract final class DateFormatter {
  static final _format = DateFormat('EEE, d MMM yyyy', 'id_ID');
  static final _shortFormat = DateFormat('EEE, d MMM', 'id_ID');

  static String format(DateTime date) => _format.format(date);

  static String formatShort(DateTime date) => _shortFormat.format(date);
}
