import 'package:intl/intl.dart';

/// Requires `initializeDateFormatting('id_ID', null)` to have run once
/// (done in `bootstrap()`) before the `id_ID` locale data is available.
abstract final class DateFormatter {
  static final _format = DateFormat('EEE, d MMM yyyy', 'id_ID');

  static String format(DateTime date) => _format.format(date);
}
