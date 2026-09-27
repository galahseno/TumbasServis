import 'package:flutter_test/flutter_test.dart';
import 'package:tumbas_servis/core/domain/model/booking/status_event.dart';
import 'package:tumbas_servis/core/domain/model/booking/unit_status.dart';

void main() {
  group('StatusEvent', () {
    final timestamp = DateTime(2026, 9, 27, 10);
    final event = StatusEvent(status: UnitStatus.checkIn, timestamp: timestamp);

    test('copyWith overrides only given fields', () {
      final updated = event.copyWith(note: 'Motor tiba');

      expect(updated.note, 'Motor tiba');
      expect(updated.status, UnitStatus.checkIn);
      expect(updated.timestamp, timestamp);
    });

    test('equality is field-based', () {
      final other = StatusEvent(
        status: UnitStatus.checkIn,
        timestamp: timestamp,
      );

      expect(event, other);
      expect(event.hashCode, other.hashCode);
    });

    test('different note is not equal', () {
      final other = StatusEvent(
        status: UnitStatus.checkIn,
        timestamp: timestamp,
        note: 'x',
      );

      expect(event, isNot(other));
    });
  });
}
