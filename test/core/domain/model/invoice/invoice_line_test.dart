import 'package:flutter_test/flutter_test.dart';
import 'package:tumbas_servis/core/domain/model/invoice/invoice_line.dart';

void main() {
  group('InvoiceLine', () {
    const line = InvoiceLine(
      unitCode: '-A',
      label: 'Ganti oli',
      qty: 1,
      price: 50000,
    );

    test('copyWith overrides only given fields', () {
      final updated = line.copyWith(qty: 2);

      expect(updated.qty, 2);
      expect(updated.label, 'Ganti oli');
    });

    test('equality is field-based', () {
      const other = InvoiceLine(
        unitCode: '-A',
        label: 'Ganti oli',
        qty: 1,
        price: 50000,
      );

      expect(line, other);
      expect(line.hashCode, other.hashCode);
    });

    test('different price is not equal', () {
      const other = InvoiceLine(
        unitCode: '-A',
        label: 'Ganti oli',
        qty: 1,
        price: 60000,
      );

      expect(line, isNot(other));
    });
  });
}
