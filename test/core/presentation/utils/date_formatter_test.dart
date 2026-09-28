import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:tumbas_servis/core/presentation/utils/date_formatter.dart';

void main() {
  setUpAll(() async {
    await initializeDateFormatting('id_ID', null);
  });

  test('formats 2026-09-29 (Tuesday) as Sel, 29 Sep 2026', () {
    expect(DateFormatter.format(DateTime(2026, 9, 29)), 'Sel, 29 Sep 2026');
  });
}
