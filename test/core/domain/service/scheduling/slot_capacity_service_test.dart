import 'package:flutter_test/flutter_test.dart';
import 'package:tumbas_servis/core/domain/model/workshop/time_slot.dart';
import 'package:tumbas_servis/core/domain/service/scheduling/slot_capacity_service.dart';

final _futureDay = DateTime(2026, 10, 1);
final _now = DateTime(2026, 9, 28, 10, 20);

TimeSlot _slot({
  required int hour,
  required int capacity,
  required int booked,
}) {
  return TimeSlot(
    date: _futureDay,
    hour: hour,
    capacity: capacity,
    booked: booked,
  );
}

void main() {
  const service = SlotCapacityService();

  test('shared capacity below unit count is disabled with reason', () {
    final slot = _slot(hour: 9, capacity: 5, booked: 3); // remaining 2

    expect(service.hasSharedCapacityFor(slot: slot, unitCount: 3), isFalse);
    expect(
      service.sharedChipState(slot: slot, unitCount: 3, now: _now),
      SlotChipState.short,
    );
  });

  test('canonical slot table across the day resolves the right chip per slot, '
      'and limited never appears once unitCount reaches 3', () {
    const remainingByHour = [4, 4, 2, 1, 0, 3, 2, 4, 0];
    const expected = [
      SlotChipState.available,
      SlotChipState.available,
      SlotChipState.short,
      SlotChipState.short,
      SlotChipState.full,
      SlotChipState.available,
      SlotChipState.short,
      SlotChipState.available,
      SlotChipState.full,
    ];

    for (var i = 0; i < remainingByHour.length; i++) {
      final slot = _slot(
        hour: 8 + i,
        capacity: 5,
        booked: 5 - remainingByHour[i],
      );
      final chip = service.sharedChipState(slot: slot, unitCount: 3, now: _now);
      expect(chip, expected[i], reason: 'hour ${8 + i}');
    }

    expect(expected, isNot(contains(SlotChipState.limited)));
  });

  test('split-mode sibling conflict: last seat already taken by a sibling', () {
    final slot = _slot(hour: 11, capacity: 5, booked: 4); // remaining 1

    expect(
      service.splitRemainingAfterSiblings(slot: slot, siblingsAlreadyPlaced: 1),
      0,
    );
    expect(
      service.canSplitPlaceUnit(slot: slot, siblingsAlreadyPlaced: 1),
      isFalse,
    );
    expect(
      service.splitChipState(slot: slot, siblingsAlreadyPlaced: 1, now: _now),
      SlotChipState.full,
    );
  });

  test('split-mode canonical table: sibling at 09.00 lowers only that chip, '
      '"short" never appears (a split unit only ever needs 1 seat)', () {
    const remainingByHour = [4, 4, 2, 1, 0, 3, 2, 4, 0];
    const expected = [
      SlotChipState.available, // 08
      SlotChipState.available, // 09 — remaining 4, minus 1 sibling = 3
      SlotChipState.limited, // 10
      SlotChipState.limited, // 11
      SlotChipState.full, // 12
      SlotChipState.available, // 13
      SlotChipState.limited, // 14
      SlotChipState.available, // 15
      SlotChipState.full, // 16
    ];

    for (var i = 0; i < remainingByHour.length; i++) {
      final hour = 8 + i;
      final slot = _slot(
        hour: hour,
        capacity: 5,
        booked: 5 - remainingByHour[i],
      );
      final siblingsAlreadyPlaced = hour == 9 ? 1 : 0;
      final chip = service.splitChipState(
        slot: slot,
        siblingsAlreadyPlaced: siblingsAlreadyPlaced,
        now: _now,
      );
      expect(chip, expected[i], reason: 'hour $hour');
    }

    expect(expected, isNot(contains(SlotChipState.short)));
  });

  group('D+0 cutoff (Lewat)', () {
    test('same-day slot before now+2h is past cutoff', () {
      final slot = TimeSlot(
        date: DateTime(2026, 9, 28),
        hour: 8,
        capacity: 5,
        booked: 0,
      );

      expect(service.isPastCutoff(slot: slot, now: _now), isTrue);
      expect(
        service.sharedChipState(slot: slot, unitCount: 1, now: _now),
        SlotChipState.lewat,
      );
    });

    test('same-day slot at or after now+2h is not past cutoff', () {
      final slot = TimeSlot(
        date: DateTime(2026, 9, 28),
        hour: 13,
        capacity: 5,
        booked: 0,
      );

      expect(service.isPastCutoff(slot: slot, now: _now), isFalse);
    });

    test('a future date is never past cutoff regardless of hour', () {
      final slot = TimeSlot(
        date: DateTime(2026, 9, 29),
        hour: 8,
        capacity: 5,
        booked: 0,
      );

      expect(service.isPastCutoff(slot: slot, now: _now), isFalse);
    });
  });
}
