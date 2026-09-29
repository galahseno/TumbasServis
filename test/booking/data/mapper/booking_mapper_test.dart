import 'package:flutter_test/flutter_test.dart';
import 'package:tumbas_servis/booking/data/mapper/booking_mapper.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking_draft.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking_status.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking_unit.dart';
import 'package:tumbas_servis/core/domain/model/booking/status_event.dart';
import 'package:tumbas_servis/core/domain/model/booking/unit_status.dart';
import 'package:tumbas_servis/core/domain/model/garage/motor.dart';
import 'package:tumbas_servis/core/domain/model/workshop/time_slot.dart';

BookingUnit _unit({String? complaintNote, String? mechanicId}) => BookingUnit(
  unitCode: '-A',
  motorId: 'motor_001',
  motorSnapshot: Motor(
    id: 'motor_001',
    ownerId: 'user_001',
    nickname: 'Vario',
    plateNumber: 'AB 0000 XY',
    year: 2020,
    modelId: 'model_x',
  ),
  serviceIds: const ['svc_berkala'],
  partIds: const ['part_oli'],
  complaintNote: complaintNote,
  status: UnitStatus.dikerjakan,
  statusHistory: [
    StatusEvent(
      status: UnitStatus.terjadwal,
      timestamp: DateTime(2026, 9, 29, 8),
      note: 'Dibuat.',
    ),
    StatusEvent(
      status: UnitStatus.dikerjakan,
      timestamp: DateTime(2026, 9, 29, 10),
    ),
  ],
  mechanicId: mechanicId,
  subtotal: 85000,
  durationMin: 60,
);

Booking _sharedBooking() => Booking(
  id: 'bk_1',
  code: 'TS-260929-0417',
  userId: 'user_001',
  workshopId: 'ws_001',
  units: [_unit(complaintNote: 'Ban bocor', mechanicId: 'mch_1')],
  scheduleMode: ScheduleMode.shared,
  sharedSlot: TimeSlot(
    date: DateTime(2026, 9, 29),
    hour: 9,
    capacity: 5,
    booked: 3,
  ),
  status: BookingStatus.berlangsung,
  voucherId: 'vc_001',
  subtotal: 85000,
  discount: 8500,
  total: 76500,
  createdAt: DateTime(2026, 9, 20),
);

Booking _splitBooking() => Booking(
  id: 'bk_2',
  code: 'TS-260930-0001',
  userId: 'user_001',
  workshopId: 'ws_001',
  units: [_unit()],
  scheduleMode: ScheduleMode.split,
  status: BookingStatus.terjadwal,
  subtotal: 85000,
  discount: 0,
  total: 85000,
  createdAt: DateTime(2026, 9, 20),
  completedAt: DateTime(2026, 10, 1),
);

void main() {
  test('shared-mode round-trip preserves equality', () {
    final booking = _sharedBooking();
    expect(booking.toBookingJson().toBooking(), booking);
  });

  test('split-mode round-trip with completedAt preserves equality', () {
    final booking = _splitBooking();
    final restored = booking.toBookingJson().toBooking();
    expect(restored, booking);
    expect(restored.completedAt, DateTime(2026, 10, 1));
  });

  test('null complaint_note and mechanic_id keys omitted from json', () {
    final json = _splitBooking().toBookingJson();
    final unitJson = (json['units'] as List).first as Map<String, dynamic>;
    expect(unitJson.containsKey('complaint_note'), isFalse);
    expect(unitJson.containsKey('mechanic_id'), isFalse);
  });

  test('null status event note key omitted from json', () {
    final booking = _splitBooking();
    final json = booking.toBookingJson();
    final unitJson = (json['units'] as List).first as Map<String, dynamic>;
    final history = (unitJson['status_history'] as List)
        .cast<Map<String, dynamic>>();
    expect(history.first.containsKey('note'), isTrue);
    expect(history.last.containsKey('note'), isFalse);
  });

  test('unknown enum strings fall back to unknown', () {
    final json = _splitBooking().toBookingJson();
    json['status'] = 'bogus';
    final unitJson = (json['units'] as List).first as Map<String, dynamic>;
    unitJson['status'] = 'bogus';
    final restored = json.toBooking();
    expect(restored.status, BookingStatus.unknown);
    expect(restored.units.first.status, UnitStatus.unknown);
  });
}
