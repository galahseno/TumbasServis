import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tumbas_servis/booking/data/util/time_slot_format.dart';
import 'package:tumbas_servis/booking/presentation/di/booking_presentation_module.dart';
import 'package:tumbas_servis/booking/presentation/pilih_jadwal/state/pilih_jadwal_state.dart';
import 'package:tumbas_servis/core/data/di/core_data_module.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking_draft.dart';
import 'package:tumbas_servis/core/domain/model/garage/motor.dart';
import 'package:tumbas_servis/core/domain/model/result.dart';
import 'package:tumbas_servis/core/domain/model/workshop/time_slot.dart';
import 'package:tumbas_servis/core/domain/model/workshop/workshop.dart';
import 'package:tumbas_servis/core/domain/service/scheduling/slot_capacity_service.dart';
import 'package:tumbas_servis/garage/data/di/garage_data_module.dart';
import 'package:tumbas_servis/workshop/data/di/workshop_data_module.dart';

const scheduleSearchWindowDays = 14;

DateTime dateOnly(DateTime value) =>
    DateTime(value.year, value.month, value.day);

sealed class SlotTapOutcome {
  const SlotTapOutcome();
}

class SlotTapSelected extends SlotTapOutcome {
  const SlotTapSelected();
}

class SlotTapBlocked extends SlotTapOutcome {
  const SlotTapBlocked();
}

class SlotTapShort extends SlotTapOutcome {
  const SlotTapShort({required this.slot, required this.unitCount});

  final TimeSlot slot;
  final int unitCount;
}

class SlotTapSiblingConflict extends SlotTapOutcome {
  const SlotTapSiblingConflict({required this.slot, required this.nickname});

  final TimeSlot slot;
  final String nickname;
}

class PilihJadwalViewModel extends Notifier<PilihJadwalState> {
  static const _service = SlotCapacityService();

  int _sharedRequestId = 0;
  final Map<String, int> _unitRequestIds = {};

  @override
  PilihJadwalState build() {
    _load();
    return const PilihJadwalState();
  }

  DateTime _now() => ref.read(clockProvider).now();

  DateTime today() => dateOnly(_now());

  DateTime now() => _now();

  Future<void> retry() async {
    state = state.copyWith(isLoading: true, hasError: false);
    await _load();
  }

  Future<BookingDraft?> _waitForDraft() async {
    for (var i = 0; i < 200; i++) {
      final draft = ref.read(bookingDraftProvider);
      if (draft != null) return draft;
      await Future<void>.delayed(const Duration(milliseconds: 5));
    }
    return null;
  }

  Future<void> _load() async {
    final draft = await _waitForDraft();
    if (!ref.mounted) return;
    final workshopId = draft?.workshopId;
    if (draft == null || workshopId == null) {
      state = state.copyWith(isLoading: false, hasError: true);
      return;
    }

    final workshopRepo = ref.read(workshopRepositoryProvider);
    final garageRepo = ref.read(garageRepositoryProvider);

    final workshopResult = await workshopRepo.getWorkshop(workshopId);
    if (!ref.mounted) return;
    if (workshopResult is Error<Workshop>) {
      state = state.copyWith(isLoading: false, hasError: true);
      return;
    }

    final motorsResult = await garageRepo.getMotors();
    if (!ref.mounted) return;
    if (motorsResult is Error<List<Motor>>) {
      state = state.copyWith(isLoading: false, hasError: true);
      return;
    }

    final initialDate = draft.sharedSlot != null
        ? dateOnly(draft.sharedSlot!.date)
        : dateOnly(_now());

    final slotsResult = await workshopRepo.getAvailableSlots(
      workshopId: workshopId,
      date: initialDate,
    );
    if (!ref.mounted) return;
    final slots = slotsResult is Ok<List<TimeSlot>>
        ? slotsResult.value
        : const <TimeSlot>[];

    state = state.copyWith(
      isLoading: false,
      hasError: false,
      workshop: (workshopResult as Ok<Workshop>).value,
      motorsById: {
        for (final motor in (motorsResult as Ok<List<Motor>>).value)
          motor.id: motor,
      },
      sharedDate: initialDate,
      sharedSlots: slots,
    );

    await _refreshAllFullNextDate(
      from: initialDate,
      unitCount: draft.selectedMotorIds.length,
      slotsOnDate: slots,
      requestId: _sharedRequestId,
    );
  }

  bool isDayPureFull(List<TimeSlot> slots) =>
      slots.isNotEmpty && slots.every((slot) => slot.remaining <= 0);

  bool noHourFits(List<TimeSlot> slots, int unitCount, DateTime now) {
    if (slots.isEmpty) return false;
    return slots.every((slot) {
      final chip = _service.sharedChipState(
        slot: slot,
        unitCount: unitCount,
        now: now,
      );
      return chip == SlotChipState.full ||
          chip == SlotChipState.short ||
          chip == SlotChipState.lewat;
    });
  }

  Future<void> _refreshAllFullNextDate({
    required DateTime from,
    required int unitCount,
    required List<TimeSlot> slotsOnDate,
    required int requestId,
  }) async {
    if (!isDayPureFull(slotsOnDate)) {
      state = state.copyWith(allFullNextDate: null, allFullSearching: false);
      return;
    }

    state = state.copyWith(allFullSearching: true, allFullNextDate: null);
    final workshop = state.workshop;
    if (workshop == null) return;
    final workshopRepo = ref.read(workshopRepositoryProvider);

    for (var i = 1; i <= scheduleSearchWindowDays; i++) {
      final candidate = from.add(Duration(days: i));
      final result = await workshopRepo.getAvailableSlots(
        workshopId: workshop.id,
        date: candidate,
      );
      if (!ref.mounted || requestId != _sharedRequestId) return;
      if (result is Ok<List<TimeSlot>> &&
          !noHourFits(result.value, unitCount, _now())) {
        state = state.copyWith(
          allFullSearching: false,
          allFullNextDate: candidate,
        );
        return;
      }
    }
    state = state.copyWith(allFullSearching: false, allFullNextDate: null);
  }

  Future<void> selectDate(DateTime date) async {
    final normalized = dateOnly(date);
    if (normalized == state.sharedDate) return;

    final requestId = ++_sharedRequestId;
    state = state.copyWith(
      sharedDate: normalized,
      sharedSlotsLoading: true,
      allFullNextDate: null,
      allFullSearching: false,
    );
    final cleared = ref.read(bookingDraftProvider.notifier).clearSharedSlot();

    final workshop = state.workshop;
    if (workshop == null) return;
    final result = await ref
        .read(workshopRepositoryProvider)
        .getAvailableSlots(workshopId: workshop.id, date: normalized);
    if (!ref.mounted || requestId != _sharedRequestId) return;
    final slots = result is Ok<List<TimeSlot>>
        ? result.value
        : const <TimeSlot>[];
    state = state.copyWith(sharedSlots: slots, sharedSlotsLoading: false);
    await cleared;
    if (!ref.mounted || requestId != _sharedRequestId) return;

    final unitCount =
        ref.read(bookingDraftProvider)?.selectedMotorIds.length ?? 0;
    await _refreshAllFullNextDate(
      from: normalized,
      unitCount: unitCount,
      slotsOnDate: slots,
      requestId: requestId,
    );
  }

  SlotChipState sharedChipStateFor(TimeSlot slot, int unitCount) =>
      _service.sharedChipState(slot: slot, unitCount: unitCount, now: _now());

  Future<SlotTapOutcome> selectSharedSlot(TimeSlot slot, int unitCount) async {
    final chip = sharedChipStateFor(slot, unitCount);
    switch (chip) {
      case SlotChipState.lewat:
      case SlotChipState.full:
        return const SlotTapBlocked();
      case SlotChipState.short:
        return SlotTapShort(slot: slot, unitCount: unitCount);
      case SlotChipState.limited:
      case SlotChipState.available:
        await ref.read(bookingDraftProvider.notifier).selectSharedSlot(slot);
        return const SlotTapSelected();
    }
  }

  Future<void> setScheduleMode(ScheduleMode mode) async {
    await ref.read(bookingDraftProvider.notifier).setScheduleMode(mode);
  }

  void toggleExpanded(String motorId) {
    final next = state.expandedMotorId == motorId ? null : motorId;
    state = state.copyWith(expandedMotorId: next);
    if (next != null && !state.unitDates.containsKey(next)) {
      selectUnitDate(next, state.sharedDate ?? dateOnly(_now()));
    }
  }

  Future<void> selectUnitDate(String motorId, DateTime date) async {
    final normalized = dateOnly(date);
    final requestId = (_unitRequestIds[motorId] ?? 0) + 1;
    _unitRequestIds[motorId] = requestId;
    state = state.copyWith(
      unitDates: {...state.unitDates, motorId: normalized},
      unitSlotsLoading: {...state.unitSlotsLoading, motorId},
    );
    final cleared = ref
        .read(bookingDraftProvider.notifier)
        .clearUnitSlot(motorId);

    final workshop = state.workshop;
    if (workshop == null) return;
    final result = await ref
        .read(workshopRepositoryProvider)
        .getAvailableSlots(workshopId: workshop.id, date: normalized);
    if (!ref.mounted || _unitRequestIds[motorId] != requestId) return;
    final slots = result is Ok<List<TimeSlot>>
        ? result.value
        : const <TimeSlot>[];
    final loading = {...state.unitSlotsLoading}..remove(motorId);
    state = state.copyWith(
      unitSlotsByMotor: {...state.unitSlotsByMotor, motorId: slots},
      unitSlotsLoading: loading,
    );
    await cleared;
  }

  Future<void> splitFromShortSlot(TimeSlot slot) async {
    final draftNotifier = ref.read(bookingDraftProvider.notifier);
    final draft = ref.read(bookingDraftProvider);
    if (draft == null) return;

    final date = dateOnly(slot.date);
    final seated = draft.selectedMotorIds.take(slot.remaining).toList();
    final next = draft.selectedMotorIds
        .where((id) => !seated.contains(id))
        .firstOrNull;
    final daySlots = state.sharedSlots;

    state = state.copyWith(
      unitDates: {...state.unitDates, for (final id in seated) id: date},
      unitSlotsByMotor: {
        ...state.unitSlotsByMotor,
        for (final id in seated) id: daySlots,
      },
      expandedMotorId: next,
    );

    await draftNotifier.setScheduleMode(ScheduleMode.split);
    for (final id in seated) {
      await draftNotifier.selectUnitSlot(id, slot);
    }
    if (next != null && !state.unitSlotsByMotor.containsKey(next)) {
      await selectUnitDate(next, date);
    }
  }

  int _siblingsAlreadyPlaced(
    TimeSlot slot,
    String excludingMotorId,
    BookingDraft draft,
  ) {
    final key = slot.slotKey;
    var count = 0;
    for (final entry in draft.unitSlots.entries) {
      if (entry.key != excludingMotorId && entry.value.slotKey == key) {
        count++;
      }
    }
    return count;
  }

  SlotChipState splitChipStateFor(
    TimeSlot slot,
    String motorId,
    BookingDraft draft,
  ) => _service.splitChipState(
    slot: slot,
    siblingsAlreadyPlaced: _siblingsAlreadyPlaced(slot, motorId, draft),
    now: _now(),
  );

  String? _siblingNickname(TimeSlot slot, String motorId, BookingDraft draft) {
    final key = slot.slotKey;
    for (final entry in draft.unitSlots.entries) {
      if (entry.key != motorId && entry.value.slotKey == key) {
        return state.motorsById[entry.key]?.nickname ?? 'motor lain';
      }
    }
    return null;
  }

  String? siblingConflictLabel(
    TimeSlot slot,
    String motorId,
    BookingDraft draft,
  ) {
    if (slot.remaining <= 0) return null;
    final nickname = _siblingNickname(slot, motorId, draft);
    if (nickname == null) return null;
    return '${slot.hour.toString().padLeft(2, '0')}.00 sudah dipakai '
        '$nickname';
  }

  Future<SlotTapOutcome> selectUnitSlot(
    String motorId,
    TimeSlot slot,
    BookingDraft draft,
  ) async {
    final chip = splitChipStateFor(slot, motorId, draft);
    if (chip == SlotChipState.lewat) return const SlotTapBlocked();
    if (chip == SlotChipState.full) {
      final nickname = slot.remaining > 0
          ? _siblingNickname(slot, motorId, draft)
          : null;
      return nickname == null
          ? const SlotTapBlocked()
          : SlotTapSiblingConflict(slot: slot, nickname: nickname);
    }
    await ref.read(bookingDraftProvider.notifier).selectUnitSlot(motorId, slot);
    return const SlotTapSelected();
  }
}
