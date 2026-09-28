import 'package:intl/intl.dart';

abstract final class TimeFormatter {
  static final _format = DateFormat('HH.mm');

  static String format(DateTime time) => _format.format(time);
}
