import 'package:flutter_test/flutter_test.dart';
import 'package:tumbas_servis/booking/data/util/time_slot_format.dart';
import 'package:tumbas_servis/core/domain/model/workshop/time_slot.dart';

TimeSlot _slot(DateTime date, int hour) =>
    TimeSlot(date: date, hour: hour, capacity: 5, booked: 0);

void main() {
  test('slotKey not zero-padded', () {
    expect(_slot(DateTime(2027, 1, 5), 9).slotKey, '2027-1-5|9');
  });

  test('auditLabel zero-padded', () {
    expect(_slot(DateTime(2027, 1, 5), 9).auditLabel, '2027-01-05 09:00');
  });

  test('auditLabel double-digit values unchanged', () {
    expect(
      _slot(DateTime(2026, 10, 12), 14).auditLabel,
      '2026-10-12 14:00',
    );
  });
}
