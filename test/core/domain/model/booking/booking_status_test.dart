import 'package:flutter_test/flutter_test.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking_status.dart';

void main() {
  group('BookingStatusX.fromString', () {
    test('parses every known value', () {
      expect(BookingStatusX.fromString('terjadwal'), BookingStatus.terjadwal);
      expect(
        BookingStatusX.fromString('berlangsung'),
        BookingStatus.berlangsung,
      );
      expect(BookingStatusX.fromString('selesai'), BookingStatus.selesai);
      expect(BookingStatusX.fromString('dibatalkan'), BookingStatus.dibatalkan);
    });

    test('falls back to unknown instead of throwing', () {
      expect(BookingStatusX.fromString('bogus'), BookingStatus.unknown);
      expect(BookingStatusX.fromString(null), BookingStatus.unknown);
    });
  });
}
