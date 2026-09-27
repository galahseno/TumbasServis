import 'package:flutter_test/flutter_test.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking_draft.dart';

void main() {
  group('ScheduleModeX.fromString', () {
    test('parses every known value', () {
      expect(ScheduleModeX.fromString('shared'), ScheduleMode.shared);
      expect(ScheduleModeX.fromString('split'), ScheduleMode.split);
    });

    test('falls back to unknown instead of throwing', () {
      expect(ScheduleModeX.fromString('bogus'), ScheduleMode.unknown);
      expect(ScheduleModeX.fromString(null), ScheduleMode.unknown);
    });
  });

  group('UnitConfig.isComplaintNoteValid', () {
    test('accepts a null complaint note', () {
      const config = UnitConfig(serviceIds: ['s1'], partIds: []);

      expect(config.isComplaintNoteValid, isTrue);
    });

    test('accepts complaint note exactly at the 250-char boundary', () {
      final config = UnitConfig(
        serviceIds: const ['s1'],
        partIds: const [],
        complaintNote: 'x' * UnitConfig.complaintNoteMaxLength,
      );

      expect(config.isComplaintNoteValid, isTrue);
    });

    test('rejects complaint note over the 250-char boundary', () {
      final config = UnitConfig(
        serviceIds: const ['s1'],
        partIds: const [],
        complaintNote: 'x' * (UnitConfig.complaintNoteMaxLength + 1),
      );

      expect(config.isComplaintNoteValid, isFalse);
    });
  });
}
