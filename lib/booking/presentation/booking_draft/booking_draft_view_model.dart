import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tumbas_servis/booking/data/di/booking_data_module.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking_draft.dart';
import 'package:tumbas_servis/core/domain/model/booking/unit_status.dart';
import 'package:tumbas_servis/core/domain/model/garage/motor.dart';
import 'package:tumbas_servis/core/domain/model/result.dart';

const bookingDraftMaxMotors = 5;

class BookingDraftViewModel extends Notifier<BookingDraft?> {
  Set<String> _motorIdsWithActiveBooking = {};

  @override
  BookingDraft? build() {
    _load();
    return null;
  }

  Future<void> _load() async {
    final repo = ref.read(bookingRepositoryProvider);

    final bookingsResult = await repo.getBookings();
    if (!ref.mounted) return;
    if (bookingsResult is Ok<List<Booking>>) {
      _motorIdsWithActiveBooking = {
        for (final booking in bookingsResult.value)
          for (final unit in booking.units)
            if (!unit.status.isTerminal) unit.motorId,
      };
    }

    final currentResult = await repo.getCurrentDraft();
    if (!ref.mounted) return;
    if (currentResult is Ok<BookingDraft?> && currentResult.value != null) {
      state = currentResult.value;
      return;
    }

    final createdResult = await repo.createDraft();
    if (!ref.mounted) return;
    if (createdResult is Ok<BookingDraft>) state = createdResult.value;
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
    await ref.read(bookingRepositoryProvider).deleteDraft();
    if (!ref.mounted) return;
    state = null;
    await _load();
  }

  Future<void> _persist(BookingDraft draft) async {
    state = draft;
    final result = await ref.read(bookingRepositoryProvider).updateDraft(draft);
    if (!ref.mounted) return;
    if (result is Ok<BookingDraft>) state = result.value;
  }
}
