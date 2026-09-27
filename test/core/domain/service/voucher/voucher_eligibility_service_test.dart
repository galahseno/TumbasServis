import 'package:flutter_test/flutter_test.dart';
import 'package:tumbas_servis/core/domain/model/catalog/voucher.dart';
import 'package:tumbas_servis/core/domain/service/voucher/voucher_eligibility_service.dart';

final _now = DateTime(2026, 9, 27);
final _farFuture = DateTime(2099, 1, 1);

final _diskon10 = Voucher(
  id: 'v-diskon10',
  code: 'DISKON10',
  label: 'Diskon 10% servis ≥2 motor',
  discountType: DiscountType.percent,
  discountValue: 10,
  minUnits: 2,
  validUntil: _farFuture,
);

final _hemat25 = Voucher(
  id: 'v-hemat25',
  code: 'HEMAT25',
  label: 'Potongan Rp25.000 min. belanja Rp300.000',
  discountType: DiscountType.flat,
  discountValue: 25000,
  minSubtotal: 300000,
  validUntil: _farFuture,
);

final _fleetVoucher15 = Voucher(
  id: 'v-fleet15',
  code: 'FLEET15',
  label: 'Diskon 15% min. 4 motor',
  discountType: DiscountType.percent,
  discountValue: 15,
  minUnits: 4,
  validUntil: _farFuture,
);

final _hemat75 = Voucher(
  id: 'v-hemat75',
  code: 'HEMAT75',
  label: 'Potongan Rp75.000 min. belanja Rp500.000',
  discountType: DiscountType.flat,
  discountValue: 75000,
  minSubtotal: 500000,
  validUntil: _farFuture,
);

void main() {
  const service = VoucherEligibilityService();

  group('3-unit canonical booking (subtotal 428000, unitCount 3)', () {
    test('DISKON10 is eligible for 42800 off', () {
      final result = service.evaluate(
        voucher: _diskon10,
        unitCount: 3,
        subtotal: 428000,
        now: _now,
      );
      expect(result.isEligible, isTrue);
      expect(result.discountAmount, 42800);
    });

    test('HEMAT25 is eligible for 25000 off, total 403000', () {
      final result = service.evaluate(
        voucher: _hemat25,
        unitCount: 3,
        subtotal: 428000,
        now: _now,
      );
      expect(result.isEligible, isTrue);
      expect(result.discountAmount, 25000);
      expect(428000 - result.discountAmount!, 403000);
    });

    test(
      'a min-4-unit voucher is ineligible with the exact shortfall message',
      () {
        final result = service.evaluate(
          voucher: _fleetVoucher15,
          unitCount: 3,
          subtotal: 428000,
          now: _now,
        );
        expect(result.isEligible, isFalse);
        expect(result.reason, VoucherIneligibilityReason.minUnitsNotMet);
        expect(
          service.shortfallMessage(voucher: _fleetVoucher15, result: result),
          'Butuh min. 4 motor',
        );
      },
    );

    test('HEMAT75 is ineligible with the exact Rp shortfall message', () {
      final result = service.evaluate(
        voucher: _hemat75,
        unitCount: 3,
        subtotal: 428000,
        now: _now,
      );
      expect(result.isEligible, isFalse);
      expect(result.reason, VoucherIneligibilityReason.minSubtotalNotMet);
      expect(result.missingSubtotalAmount, 72000);
      expect(
        service.shortfallMessage(voucher: _hemat75, result: result),
        'Min. belanja Rp500.000 — kurang Rp72.000',
      );
    });
  });

  group('1-unit booking (subtotal 85000, unitCount 1)', () {
    test('all four vouchers are ineligible', () {
      for (final voucher in [_diskon10, _hemat25, _fleetVoucher15, _hemat75]) {
        final result = service.evaluate(
          voucher: voucher,
          unitCount: 1,
          subtotal: 85000,
          now: _now,
        );
        expect(result.isEligible, isFalse, reason: voucher.code);
      }
    });

    test('DISKON10 shows "Butuh min. 2 motor"', () {
      final result = service.evaluate(
        voucher: _diskon10,
        unitCount: 1,
        subtotal: 85000,
        now: _now,
      );
      expect(
        service.shortfallMessage(voucher: _diskon10, result: result),
        'Butuh min. 2 motor',
      );
    });
  });

  test(
    'an expired voucher is ineligible regardless of unit/subtotal match',
    () {
      final expired = Voucher(
        id: 'v-expired',
        code: 'EXPIRED',
        label: 'Sudah lewat',
        discountType: DiscountType.flat,
        discountValue: 10000,
        validUntil: DateTime(2020, 1, 1),
      );

      final result = service.evaluate(
        voucher: expired,
        unitCount: 5,
        subtotal: 1000000,
        now: _now,
      );

      expect(result.isEligible, isFalse);
      expect(result.reason, VoucherIneligibilityReason.expired);
    },
  );
}
