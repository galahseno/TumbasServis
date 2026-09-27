import 'package:flutter_test/flutter_test.dart';
import 'package:tumbas_servis/core/domain/model/workshop/time_slot.dart';

void main() {
  group('TimeSlot.remaining', () {
    test('is capacity minus booked', () {
      final slot = TimeSlot(
        date: DateTime(2026, 9, 29),
        hour: 9,
        capacity: 5,
        booked: 2,
      );

      expect(slot.remaining, 3);
    });

    test('is zero when fully booked', () {
      final slot = TimeSlot(
        date: DateTime(2026, 9, 29),
        hour: 9,
        capacity: 5,
        booked: 5,
      );

      expect(slot.remaining, 0);
    });
  });
}
