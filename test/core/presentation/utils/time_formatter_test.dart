import 'package:flutter_test/flutter_test.dart';
import 'package:tumbas_servis/core/presentation/utils/time_formatter.dart';

void main() {
  test('formats 09:00 as 09.00', () {
    expect(TimeFormatter.format(DateTime(2026, 9, 29, 9)), '09.00');
  });
}
