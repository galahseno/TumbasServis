import 'package:flutter_test/flutter_test.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking_status.dart';
import 'package:tumbas_servis/core/domain/model/booking/unit_status.dart';
import 'package:tumbas_servis/core/domain/service/status/booking_status_derivation.dart';

void main() {
  const derivation = BookingStatusDerivation();

  test('Terjadwal while every unit has not checked in', () {
    expect(
      derivation.deriveStatus([UnitStatus.terjadwal, UnitStatus.terjadwal]),
      BookingStatus.terjadwal,
    );
  });

  test('Berlangsung while any unit is mid-flow', () {
    expect(
      derivation.deriveStatus([UnitStatus.checkIn, UnitStatus.terjadwal]),
      BookingStatus.berlangsung,
    );
    expect(
      derivation.deriveStatus([UnitStatus.dikerjakan, UnitStatus.qc]),
      BookingStatus.berlangsung,
    );
  });

  test('Selesai once every unit is Selesai', () {
    expect(
      derivation.deriveStatus([UnitStatus.selesai, UnitStatus.selesai]),
      BookingStatus.selesai,
    );
  });

  test('Selesai for a mix of Selesai/Dibatalkan with at least one Selesai', () {
    expect(
      derivation.deriveStatus([UnitStatus.selesai, UnitStatus.dibatalkan]),
      BookingStatus.selesai,
    );
  });

  test('Dibatalkan only if every unit is Dibatalkan', () {
    expect(
      derivation.deriveStatus([UnitStatus.dibatalkan, UnitStatus.dibatalkan]),
      BookingStatus.dibatalkan,
    );
  });

  test(
    'a cancelled unit alongside units that have not started stays Terjadwal',
    () {
      expect(
        derivation.deriveStatus([UnitStatus.dibatalkan, UnitStatus.terjadwal]),
        BookingStatus.terjadwal,
      );
    },
  );
}
