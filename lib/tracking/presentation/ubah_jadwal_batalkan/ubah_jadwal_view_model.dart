import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tumbas_servis/booking/data/di/booking_data_module.dart';
import 'package:tumbas_servis/booking/data/util/time_slot_format.dart';
import 'package:tumbas_servis/core/data/di/core_data_module.dart';
import 'package:tumbas_servis/core/domain/model/booking/unit_status.dart';
import 'package:tumbas_servis/core/domain/model/result.dart';
import 'package:tumbas_servis/core/domain/model/workshop/time_slot.dart';
import 'package:tumbas_servis/core/domain/service/scheduling/slot_capacity_service.dart';
import 'package:tumbas_servis/tracking/presentation/ubah_jadwal_batalkan/state/ubah_jadwal_state.dart';
import 'package:tumbas_servis/workshop/data/di/workshop_data_module.dart';

const rescheduleWindowDays = 14;

DateTime _dateOnly(DateTime value) =>
    DateTime(value.year, value.month, value.day);

class UbahJadwalViewModel extends Notifier<UbahJadwalState> {
  UbahJadwalViewModel(this.args);

  final UbahJadwalArgs args;

  static const _service = SlotCapacityService();

  int _requestId = 0;

  TimeSlot? get currentSlot => args.booking.sharedSlot;

  int get unitCount =>
      args.booking.units.where((u) => u.status != UnitStatus.dibatalkan).length;

  DateTime now() => ref.read(clockProvider).now();

  DateTime today() => _dateOnly(now());

  List<DateTime> get dates {
    final start = today();
    final list = [
      for (var i = 0; i <= rescheduleWindowDays; i++)
        start.add(Duration(days: i)),
    ];
    final current = currentSlot;
    if (current != null) {
      final day = _dateOnly(current.date);
      if (!list.contains(day)) {
        list
          ..add(day)
          ..sort();
      }
    }
    return list;
  }

  bool isCurrent(TimeSlot slot) =>
      currentSlot != null && currentSlot!.slotKey == slot.slotKey;

  SlotChipState chipState(TimeSlot slot) {
    if (isCurrent(slot)) return SlotChipState.available;
    return _service.sharedChipState(
      slot: slot,
      unitCount: unitCount,
      now: now(),
    );
  }

  @override
  UbahJadwalState build() {
    final current = args.booking.sharedSlot;
    final date = current != null ? _dateOnly(current.date) : today();
    _loadSlots(date, markLoading: false);
    return UbahJadwalState(selectedDate: date, selectedSlot: current);
  }

  Future<void> selectDate(DateTime date) async {
    final day = _dateOnly(date);
    if (day == state.selectedDate) return;
    final keepCurrent =
        currentSlot != null && _dateOnly(currentSlot!.date) == day;
    state = state.copyWith(
      selectedDate: day,
      selectedSlot: keepCurrent ? currentSlot : null,
      saveFailed: false,
    );
    await _loadSlots(day);
  }

  Future<void> retrySlots() => _loadSlots(state.selectedDate);

  Future<void> _loadSlots(DateTime date, {bool markLoading = true}) async {
    final request = ++_requestId;
    if (markLoading) {
      state = state.copyWith(isLoadingSlots: true, slotsError: false);
    }
    final result = await ref
        .read(workshopRepositoryProvider)
        .getAvailableSlots(workshopId: args.booking.workshopId, date: date);
    if (!ref.mounted || request != _requestId) return;
    state = switch (result) {
      Ok<List<TimeSlot>>(:final value) => state.copyWith(
        isLoadingSlots: false,
        slots: value,
      ),
      Error<List<TimeSlot>>() => state.copyWith(
        isLoadingSlots: false,
        slotsError: true,
      ),
    };
  }

  void selectSlot(TimeSlot slot) {
    final chip = chipState(slot);
    if (chip == SlotChipState.lewat ||
        chip == SlotChipState.full ||
        chip == SlotChipState.short) {
      return;
    }
    state = state.copyWith(selectedSlot: slot, saveFailed: false);
  }

  bool get canSave => state.selectedSlot != null && !state.isSaving;

  Future<bool> save() async {
    final slot = state.selectedSlot;
    if (slot == null || state.isSaving) return false;
    if (isCurrent(slot)) return true;

    state = state.copyWith(isSaving: true, saveFailed: false);
    final result = await ref
        .read(bookingRepositoryProvider)
        .rescheduleBooking(id: args.booking.id, newSharedSlot: slot);
    if (!ref.mounted) return false;
    if (result is Ok) {
      state = state.copyWith(isSaving: false);
      return true;
    }
    state = state.copyWith(isSaving: false, saveFailed: true);
    return false;
  }
}
