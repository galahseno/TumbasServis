import 'package:flutter_test/flutter_test.dart';
import 'package:tumbas_servis/core/presentation/utils/currency_formatter.dart';

void main() {
  test('formats 412000 as Rp412.000', () {
    expect(CurrencyFormatter.format(412000), 'Rp412.000');
  });
}
