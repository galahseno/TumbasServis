import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tumbas_servis/booking/data/di/booking_data_module.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking_draft.dart';
import 'package:tumbas_servis/core/domain/model/booking/unit_status.dart';
import 'package:tumbas_servis/core/domain/model/garage/motor.dart';
import 'package:tumbas_servis/core/domain/model/result.dart';
import 'package:tumbas_servis/core/domain/model/workshop/time_slot.dart';

const bookingDraftMaxMotors = 5;

class BookingDraftViewModel extends Notifier<BookingDraft?> {
  Set<String> _motorIdsWithActiveBooking = {};
  Future<void> _writeChain = Future<void>.value();
  bool _writeQueued = false;
  int _prunedSinceNotice = 0;
  List<String>? _pendingPreselectMotorIds;

  @override
  BookingDraft? build() {
    _load();
    return null;
  }

  Future<void> _load() async {
    final repo = ref.read(bookingRepositoryProvider);

    await _loadActiveBookingMotorIds();
    if (!ref.mounted) return;

    final currentResult = await repo.getCurrentDraft();
    if (!ref.mounted) return;
    if (currentResult is Ok<BookingDraft?> && currentResult.value != null) {
      state = currentResult.value;
      await refreshActiveBookings();
      await _applyPendingPreselect();
      return;
    }

    final createdResult = await repo.createDraft();
    if (!ref.mounted) return;
    if (createdResult is Ok<BookingDraft>) state = createdResult.value;
    await _applyPendingPreselect();
  }

  Future<void> preselectMotor(String motorId) => preselectMotors([motorId]);

  Future<void> preselectMotors(List<String> motorIds) async {
    if (state == null) {
      _pendingPreselectMotorIds = motorIds;
      return;
    }
    for (final motorId in motorIds) {
      if (_motorIdsWithActiveBooking.contains(motorId)) continue;
      await selectMotor(motorId);
    }
  }

  Future<void> _applyPendingPreselect() async {
    final motorIds = _pendingPreselectMotorIds;
    _pendingPreselectMotorIds = null;
    if (motorIds == null || !ref.mounted) return;
    await preselectMotors(motorIds);
  }

  Future<void> _loadActiveBookingMotorIds() async {
    final bookingsResult = await ref
        .read(bookingRepositoryProvider)
        .getBookings();
    if (!ref.mounted) return;
    if (bookingsResult is Ok<List<Booking>>) {
      _motorIdsWithActiveBooking = {
        for (final booking in bookingsResult.value)
          for (final unit in booking.units)
            if (!unit.status.isTerminal) unit.motorId,
      };
    }
  }

  Future<int> refreshActiveBookings() async {
    await _loadActiveBookingMotorIds();
    if (!ref.mounted) return 0;
    final draft = state;
    if (draft == null) return 0;

    final blocked = draft.selectedMotorIds
        .where(_motorIdsWithActiveBooking.contains)
        .toSet();
    if (blocked.isEmpty) return 0;

    _prunedSinceNotice += blocked.length;
    await _persist(
      draft.copyWith(
        selectedMotorIds: draft.selectedMotorIds
            .where((id) => !blocked.contains(id))
            .toList(),
        unitConfigs: {
          for (final entry in draft.unitConfigs.entries)
            if (!blocked.contains(entry.key)) entry.key: entry.value,
        },
        unitSlots: {
          for (final entry in draft.unitSlots.entries)
            if (!blocked.contains(entry.key)) entry.key: entry.value,
        },
      ),
    );
    return blocked.length;
  }

  int takePrunedCount() {
    final count = _prunedSinceNotice;
    _prunedSinceNotice = 0;
    return count;
  }

  bool hasActiveBooking(String motorId) =>
      _motorIdsWithActiveBooking.contains(motorId);

  bool isMotorSelectable(Motor motor) {
    final draft = state;
    if (draft == null) return false;
    if (draft.selectedMotorIds.contains(motor.id)) return true;
    if (_motorIdsWithActiveBooking.contains(motor.id)) return false;
    return draft.selectedMotorIds.length < bookingDraftMaxMotors;
  }

  Future<void> selectMotor(String motorId) async {
    final draft = state;
    if (draft == null) return;
    if (draft.selectedMotorIds.contains(motorId)) return;
    if (draft.selectedMotorIds.length >= bookingDraftMaxMotors) return;
    await _persist(
      draft.copyWith(selectedMotorIds: [...draft.selectedMotorIds, motorId]),
    );
  }

  Future<void> deselectMotor(String motorId) async {
    final draft = state;
    if (draft == null) return;
    await _persist(
      draft.copyWith(
        selectedMotorIds: draft.selectedMotorIds
            .where((id) => id != motorId)
            .toList(),
      ),
    );
  }

  UnitConfig _configFor(BookingDraft draft, String motorId) =>
      draft.unitConfigs[motorId] ??
      const UnitConfig(serviceIds: [], partIds: []);

  Future<void> toggleService(String motorId, String serviceId) async {
    final draft = state;
    if (draft == null) return;
    final config = _configFor(draft, motorId);
    final serviceIds = config.serviceIds.contains(serviceId)
        ? config.serviceIds.where((id) => id != serviceId).toList()
        : [...config.serviceIds, serviceId];
    await setUnitConfig(motorId, config.copyWith(serviceIds: serviceIds));
  }

  Future<void> togglePart(String motorId, String partId) async {
    final draft = state;
    if (draft == null) return;
    final config = _configFor(draft, motorId);
    final partIds = config.partIds.contains(partId)
        ? config.partIds.where((id) => id != partId).toList()
        : [...config.partIds, partId];
    await setUnitConfig(motorId, config.copyWith(partIds: partIds));
  }

  Future<void> setComplaintNote(String motorId, String? note) async {
    final draft = state;
    if (draft == null) return;
    final config = _configFor(draft, motorId);
    await setUnitConfig(motorId, config.copyWith(complaintNote: note));
  }

  Future<void> setUnitConfig(String motorId, UnitConfig config) async {
    final draft = state;
    if (draft == null) return;
    await _persist(
      draft.copyWith(unitConfigs: {...draft.unitConfigs, motorId: config}),
    );
  }

  Future<void> selectWorkshop(String workshopId) async {
    final draft = state;
    if (draft == null) return;
    await _persist(draft.copyWith(workshopId: workshopId));
  }

  Future<void> setVoucher(String? voucherId) async {
    final draft = state;
    if (draft == null) return;
    await _persist(draft.copyWith(voucherId: voucherId));
  }

  Future<void> setScheduleMode(ScheduleMode mode) async {
    final draft = state;
    if (draft == null) return;
    await _persist(draft.copyWith(scheduleMode: mode));
  }

  Future<void> selectSharedSlot(TimeSlot slot) async {
    final draft = state;
    if (draft == null) return;
    await _persist(draft.copyWith(sharedSlot: slot));
  }

  Future<void> clearSharedSlot() async {
    final draft = state;
    if (draft == null) return;
    await _persist(draft.copyWith(sharedSlot: null));
  }

  Future<void> selectUnitSlot(String motorId, TimeSlot slot) async {
    final draft = state;
    if (draft == null) return;
    await _persist(
      draft.copyWith(unitSlots: {...draft.unitSlots, motorId: slot}),
    );
  }

  Future<void> clearUnitSlot(String motorId) async {
    final draft = state;
    if (draft == null) return;
    final unitSlots = {...draft.unitSlots}..remove(motorId);
    await _persist(draft.copyWith(unitSlots: unitSlots));
  }

  Future<void> removeUnit(String motorId) async {
    final draft = state;
    if (draft == null) return;
    final unitConfigs = {...draft.unitConfigs}..remove(motorId);
    await _persist(
      draft.copyWith(
        selectedMotorIds: draft.selectedMotorIds
            .where((id) => id != motorId)
            .toList(),
        unitConfigs: unitConfigs,
      ),
    );
  }

  Future<void> reset() async {
    await _writeChain;
    if (!ref.mounted) return;
    await ref.read(bookingRepositoryProvider).deleteDraft();
    if (!ref.mounted) return;
    state = null;
    await _load();
  }

  Future<void> _persist(BookingDraft draft) {
    state = draft;
    if (_writeQueued) return _writeChain;
    _writeQueued = true;
    _writeChain = _writeChain.then((_) async {
      _writeQueued = false;
      if (!ref.mounted) return;
      final latest = state;
      if (latest == null) return;
      await ref.read(bookingRepositoryProvider).updateDraft(latest);
    });
    return _writeChain;
  }
}
