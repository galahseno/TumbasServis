import 'package:tumbas_servis/core/data/service/local_store.dart';

/// Computes how many motors are booked at a given workshop/date/hour.
///
/// Composed of a deterministic mock baseline (so the same inputs always
/// produce the same slot table across app restarts, without persisting
/// anything) plus a live overlay read from the real confirmed bookings in
/// [LocalStore]. Both [WorkshopRepositoryImpl] and [BookingRepositoryImpl]
/// call this directly instead of depending on each other, avoiding a
/// provider cycle between the two repositories.
class SlotOccupancyCalculator {
  const SlotOccupancyCalculator();

  static const bookingsBox = 'bookings';

  static const _canonicalWorkshopId = 'ws_001';
  static const _canonicalYear = 2026;
  static const _canonicalMonth = 9;
  static const _canonicalDay = 29;
  static const _canonicalTable = {
    8: 1,
    9: 1,
    10: 3,
    11: 4,
    12: 5,
    13: 2,
    14: 3,
    15: 1,
    16: 5,
  };

  int baselineBooked({
    required String workshopId,
    required DateTime date,
    required int hour,
    int capacity = 5,
  }) {
    if (workshopId == _canonicalWorkshopId &&
        date.year == _canonicalYear &&
        date.month == _canonicalMonth &&
        date.day == _canonicalDay) {
      return _canonicalTable[hour] ?? 0;
    }
    final seed = '$workshopId|${date.year}-${date.month}-${date.day}|$hour';
    var hash = 0;
    for (final unit in seed.codeUnits) {
      hash = (hash * 31 + unit) & 0x7fffffff;
    }
    return hash % (capacity + 1);
  }

  Future<int> overlayBooked({
    required LocalStore localStore,
    required String workshopId,
    required DateTime date,
    required int hour,
  }) async {
    final rows = await localStore.getAll(bookingsBox);
    var count = 0;
    for (final row in rows) {
      if (row['workshop_id'] != workshopId) continue;
      final units = (row['units'] as List<dynamic>)
          .cast<Map<String, dynamic>>();
      if (row['schedule_mode'] == 'shared') {
        final slot = row['shared_slot'] as Map<String, dynamic>?;
        if (slot == null || !_matches(slot, date, hour)) continue;
        count += units.where((u) => u['status'] != 'dibatalkan').length;
      } else if (row['schedule_mode'] == 'split') {
        final unitSlots =
            (row['unit_slots'] as Map<String, dynamic>?) ?? const {};
        for (final unit in units) {
          if (unit['status'] == 'dibatalkan') continue;
          final slot = unitSlots[unit['unit_code']] as Map<String, dynamic>?;
          if (slot != null && _matches(slot, date, hour)) count++;
        }
      }
    }
    return count;
  }

  Future<int> bookedCount({
    required LocalStore localStore,
    required String workshopId,
    required DateTime date,
    required int hour,
    int capacity = 5,
  }) async {
    final baseline = baselineBooked(
      workshopId: workshopId,
      date: date,
      hour: hour,
      capacity: capacity,
    );
    final overlay = await overlayBooked(
      localStore: localStore,
      workshopId: workshopId,
      date: date,
      hour: hour,
    );
    return baseline + overlay;
  }

  bool _matches(Map<String, dynamic> slot, DateTime date, int hour) {
    final slotDate = DateTime.parse(slot['date'] as String);
    return slotDate.year == date.year &&
        slotDate.month == date.month &&
        slotDate.day == date.day &&
        slot['hour'] == hour;
  }
}
