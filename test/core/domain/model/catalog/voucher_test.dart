import 'package:flutter_test/flutter_test.dart';
import 'package:tumbas_servis/core/domain/model/catalog/voucher.dart';

void main() {
  group('DiscountTypeX.fromString', () {
    test('parses every known value', () {
      expect(DiscountTypeX.fromString('percent'), DiscountType.percent);
      expect(DiscountTypeX.fromString('flat'), DiscountType.flat);
    });

    test('falls back to unknown instead of throwing', () {
      expect(DiscountTypeX.fromString('bogus'), DiscountType.unknown);
      expect(DiscountTypeX.fromString(null), DiscountType.unknown);
    });
  });
}
