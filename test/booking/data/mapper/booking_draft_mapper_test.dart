import 'package:flutter_test/flutter_test.dart';
import 'package:tumbas_servis/booking/data/mapper/booking_draft_mapper.dart';
import 'package:tumbas_servis/booking/data/mapper/time_slot_mapper.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking_draft.dart';
import 'package:tumbas_servis/core/domain/model/workshop/time_slot.dart';

BookingDraft _draft() => BookingDraft(
  id: 'draft_1',
  selectedMotorIds: const ['motor_001', 'motor_002'],
  unitConfigs: const {
    'motor_001': UnitConfig(serviceIds: ['svc_berkala'], partIds: ['part_oli']),
    'motor_002': UnitConfig(
      serviceIds: ['svc_ganti_ban'],
      partIds: [],
      complaintNote: 'Ban depan tipis',
    ),
  },
  workshopId: 'ws_001',
  scheduleMode: ScheduleMode.shared,
  sharedSlot: TimeSlot(
    date: DateTime(2026, 9, 29),
    hour: 9,
    capacity: 5,
    booked: 3,
  ),
  unitSlots: const {},
  voucherId: 'vc_001',
  createdAt: DateTime(2026, 9, 28, 8),
  expiresAt: DateTime(2026, 9, 29, 8),
);

void main() {
  test('draft round-trip preserves equality', () {
    final draft = _draft();
    expect(draft.toDraftJson().toBookingDraft(), draft);
  });

  test('null complaint_note omitted from unit config json', () {
    final json = _draft().toDraftJson();
    final configs = json['unit_configs'] as Map<String, dynamic>;
    expect(
      (configs['motor_001'] as Map<String, dynamic>).containsKey(
        'complaint_note',
      ),
      isFalse,
    );
    expect(
      (configs['motor_002'] as Map<String, dynamic>)['complaint_note'],
      'Ban depan tipis',
    );
  });

  test('nullable workshopId and voucherId round-trip', () {
    final draft = _draft().copyWith(workshopId: null, voucherId: null);
    final restored = draft.toDraftJson().toBookingDraft();
    expect(restored.workshopId, isNull);
    expect(restored.voucherId, isNull);
  });

  test('time slot round-trip preserves equality', () {
    final slot = TimeSlot(
      date: DateTime(2026, 9, 29),
      hour: 9,
      capacity: 5,
      booked: 3,
    );
    expect(slot.toTimeSlotJson().toTimeSlot(), slot);
  });
}
