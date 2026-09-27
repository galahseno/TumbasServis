import 'package:flutter_test/flutter_test.dart';
import 'package:tumbas_servis/core/domain/model/catalog/part.dart';
import 'package:tumbas_servis/core/domain/model/catalog/service_type.dart';
import 'package:tumbas_servis/core/domain/model/catalog/voucher.dart';
import 'package:tumbas_servis/core/domain/service/pricing_duration/pricing_calculator.dart';

const _servisBerkala = ServiceType(
  id: 'svc-servis-berkala',
  name: 'Servis Berkala',
  price: 85000,
  durationMin: 60,
  requiresComplaint: false,
);

const _oliMpx1 = Part(
  id: 'part-oli-mpx1',
  name: 'AHM Oli MPX1',
  category: 'oli',
  brand: 'AHM',
  grade: 'MPX1',
  price: 58000,
  compatibleModelIds: [],
);

const _oliMpx2 = Part(
  id: 'part-oli-mpx2',
  name: 'AHM Oli MPX2',
  category: 'oli',
  brand: 'AHM',
  grade: 'MPX2',
  price: 70000,
  compatibleModelIds: [],
);

const _kampasRem = Part(
  id: 'part-kampas-rem',
  name: 'Kampas Rem',
  category: 'rem',
  brand: 'Generic',
  grade: 'standard',
  price: 45000,
  compatibleModelIds: [],
);

final _diskon10 = Voucher(
  id: 'v-diskon10',
  code: 'DISKON10',
  label: 'Diskon 10% servis ≥2 motor',
  discountType: DiscountType.percent,
  discountValue: 10,
  minUnits: 2,
  validUntil: DateTime(2099, 1, 1),
);

void main() {
  const calculator = PricingCalculator();

  group('PricingCalculator canonical 3-unit booking', () {
    test('per-unit subtotal matches design plan numbers', () {
      expect(
        calculator.unitSubtotal(services: [_servisBerkala], parts: const []),
        85000,
      );
      expect(
        calculator.unitSubtotal(services: [_servisBerkala], parts: [_oliMpx1]),
        143000,
      );
      expect(
        calculator.unitSubtotal(
          services: [_servisBerkala],
          parts: [_oliMpx2, _kampasRem],
        ),
        200000,
      );
    });

    test('fleet subtotal sums every unit', () {
      expect(calculator.fleetSubtotal([85000, 143000, 200000]), 428000);
    });

    test('DISKON10 (10%) discount and total', () {
      expect(
        calculator.voucherDiscount(subtotal: 428000, voucher: _diskon10),
        42800,
      );
      final breakdown = calculator.breakdown(
        unitSubtotals: [85000, 143000, 200000],
        voucher: _diskon10,
      );
      expect(breakdown.subtotal, 428000);
      expect(breakdown.discount, 42800);
      expect(breakdown.total, 385200);
    });
  });

  test('no voucher means zero discount and total equals subtotal', () {
    final breakdown = calculator.breakdown(
      unitSubtotals: [85000, 143000, 200000],
    );
    expect(breakdown.discount, 0);
    expect(breakdown.total, breakdown.subtotal);
  });

  test('single-unit booking has no fleet combination', () {
    final breakdown = calculator.breakdown(unitSubtotals: [85000]);
    expect(breakdown.subtotal, 85000);
    expect(breakdown.total, 85000);
  });
}
