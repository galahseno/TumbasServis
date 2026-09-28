// ignore_for_file: prefer_initializing_formals
import 'package:tumbas_servis/booking/data/util/time_slot_format.dart';
import 'package:tumbas_servis/core/data/service/local_store.dart';
import 'package:tumbas_servis/core/data/service/slot_occupancy_calculator.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking_draft.dart';
import 'package:tumbas_servis/core/domain/model/workshop/time_slot.dart';
import 'package:tumbas_servis/core/domain/service/scheduling/slot_capacity_service.dart';

class SlotCapacityValidator {
  SlotCapacityValidator({required LocalStore localStore})
    : _localStore = localStore;

  final LocalStore _localStore;

  static const _capacity = 5;
  static const _slotOccupancy = SlotOccupancyCalculator();
  static const _slotCapacityService = SlotCapacityService();

  Future<Exception?> validateDraft(BookingDraft draft) async {
    if (draft.workshopId == null) {
      return Exception('Draft belum memiliki bengkel.');
    }
    final workshopId = draft.workshopId!;

    if (draft.scheduleMode == ScheduleMode.shared) {
      final sharedSlot = draft.sharedSlot;
      if (sharedSlot == null) {
        return Exception('Draft belum memiliki jadwal.');
      }
      if (!await hasSharedCapacityFor(
        workshopId: workshopId,
        slot: sharedSlot,
        unitCount: draft.selectedMotorIds.length,
      )) {
        return Exception('Slot penuh, silakan pilih jam lain.');
      }
      return null;
    }

    for (final motorId in draft.selectedMotorIds) {
      if (draft.unitSlots[motorId] == null) {
        return Exception('Draft belum memiliki jadwal untuk salah satu motor.');
      }
    }
    if (!await canPlaceUnits(workshopId: workshopId, slots: draft.unitSlots)) {
      return Exception('Slot penuh, silakan pilih jam lain.');
    }
    return null;
  }

  Future<bool> hasSharedCapacityFor({
    required String workshopId,
    required TimeSlot slot,
    required int unitCount,
  }) async {
    final freshBooked = await _slotOccupancy.bookedCount(
      localStore: _localStore,
      workshopId: workshopId,
      date: slot.date,
      hour: slot.hour,
      capacity: _capacity,
    );
    final freshSlot = TimeSlot(
      date: slot.date,
      hour: slot.hour,
      capacity: _capacity,
      booked: freshBooked,
    );
    return _slotCapacityService.hasSharedCapacityFor(
      slot: freshSlot,
      unitCount: unitCount,
    );
  }

  Future<bool> canPlaceUnits({
    required String workshopId,
    required Map<String, TimeSlot> slots,
  }) async {
    final byKey = <String, List<String>>{};
    for (final entry in slots.entries) {
      byKey.putIfAbsent(entry.value.slotKey, () => []).add(entry.key);
    }
    for (final group in byKey.values) {
      final slot = slots[group.first]!;
      final freshBooked = await _slotOccupancy.bookedCount(
        localStore: _localStore,
        workshopId: workshopId,
        date: slot.date,
        hour: slot.hour,
        capacity: _capacity,
      );
      for (var i = 0; i < group.length; i++) {
        final freshSlot = TimeSlot(
          date: slot.date,
          hour: slot.hour,
          capacity: _capacity,
          booked: freshBooked,
        );
        if (!_slotCapacityService.canSplitPlaceUnit(
          slot: freshSlot,
          siblingsAlreadyPlaced: i,
        )) {
          return false;
        }
      }
    }
    return true;
  }
}
