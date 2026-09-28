import 'package:tumbas_servis/core/domain/model/workshop/time_slot.dart';

enum SlotChipState { lewat, full, short, limited, available }

class SlotCapacityService {
  const SlotCapacityService();

  static const int _cutoffHours = 2;
  static const int _limitedThreshold = 2;

  bool isPastCutoff({required TimeSlot slot, required DateTime now}) {
    final isSameDay =
        slot.date.year == now.year &&
        slot.date.month == now.month &&
        slot.date.day == now.day;
    if (!isSameDay) return false;
    final slotDateTime = DateTime(
      slot.date.year,
      slot.date.month,
      slot.date.day,
      slot.hour,
    );
    return slotDateTime.isBefore(now.add(const Duration(hours: _cutoffHours)));
  }

  bool hasSharedCapacityFor({required TimeSlot slot, required int unitCount}) =>
      slot.remaining >= unitCount;

  SlotChipState sharedChipState({
    required TimeSlot slot,
    required int unitCount,
    required DateTime now,
  }) {
    if (isPastCutoff(slot: slot, now: now)) return SlotChipState.lewat;
    if (slot.remaining <= 0) return SlotChipState.full;
    if (slot.remaining < unitCount) return SlotChipState.short;
    if (slot.remaining <= _limitedThreshold) return SlotChipState.limited;
    return SlotChipState.available;
  }

  int splitRemainingAfterSiblings({
    required TimeSlot slot,
    required int siblingsAlreadyPlaced,
  }) => slot.remaining - siblingsAlreadyPlaced;

  bool canSplitPlaceUnit({
    required TimeSlot slot,
    required int siblingsAlreadyPlaced,
  }) =>
      splitRemainingAfterSiblings(
        slot: slot,
        siblingsAlreadyPlaced: siblingsAlreadyPlaced,
      ) >
      0;

  SlotChipState splitChipState({
    required TimeSlot slot,
    required int siblingsAlreadyPlaced,
    required DateTime now,
  }) {
    if (isPastCutoff(slot: slot, now: now)) return SlotChipState.lewat;
    final remaining = splitRemainingAfterSiblings(
      slot: slot,
      siblingsAlreadyPlaced: siblingsAlreadyPlaced,
    );
    if (remaining <= 0) return SlotChipState.full;
    if (remaining <= _limitedThreshold) return SlotChipState.limited;
    return SlotChipState.available;
  }
}
