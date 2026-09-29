import 'package:tumbas_servis/core/domain/model/booking/booking.dart';
import 'package:tumbas_servis/core/domain/model/booking/unit_status.dart';
import 'package:tumbas_servis/core/domain/model/catalog/voucher.dart';
import 'package:tumbas_servis/core/domain/model/invoice/invoice_line.dart';

import 'tracking_fixtures.dart';

final voucherDiskon10 = Voucher(
  id: 'voucher_diskon10',
  code: 'DISKON10',
  label: 'Diskon 10% servis ≥2 motor',
  discountType: DiscountType.percent,
  discountValue: 10,
  minUnits: 2,
  validUntil: DateTime(2026, 10, 31),
);

Booking canonicalFinishedBooking({String id = 'fin1'}) =>
    trackedBooking(id, [
      trackedUnit(
        '-A',
        UnitStatus.selesai,
        motorId: 'm1',
        nickname: 'Vario 125',
        mechanicId: 'mech_002',
      ),
      trackedUnit(
        '-B',
        UnitStatus.selesai,
        motorId: 'm2',
        nickname: 'Beat 110',
        mechanicId: 'mech_001',
      ),
      trackedUnit(
        '-C',
        UnitStatus.selesai,
        motorId: 'm3',
        nickname: 'PCX 160',
        mechanicId: 'mech_002',
      ),
    ]).copyWith(
      voucherId: 'voucher_diskon10',
      discount: 42800,
      completedAt: DateTime(2026, 9, 29, 11, 8),
    );

Booking singleMechanicFinishedBooking({String id = 'fin2'}) =>
    trackedBooking(id, [
      trackedUnit(
        '-A',
        UnitStatus.selesai,
        motorId: 'm2',
        nickname: 'Beat 110',
        mechanicId: 'mech_001',
      ),
    ]);

const canonicalInvoiceLines = [
  InvoiceLine(unitCode: '-A', label: 'Servis Berkala', qty: 1, price: 85000),
  InvoiceLine(unitCode: '-B', label: 'Servis Berkala', qty: 1, price: 85000),
  InvoiceLine(unitCode: '-B', label: 'AHM Oli MPX1', qty: 1, price: 58000),
  InvoiceLine(unitCode: '-C', label: 'Servis Berkala', qty: 1, price: 85000),
  InvoiceLine(unitCode: '-C', label: 'AHM Oli MPX2', qty: 1, price: 70000),
  InvoiceLine(unitCode: '-C', label: 'Kampas Rem', qty: 1, price: 45000),
];
