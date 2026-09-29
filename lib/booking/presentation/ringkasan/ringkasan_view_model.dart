import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tumbas_servis/booking/data/di/booking_data_module.dart';
import 'package:tumbas_servis/booking/presentation/di/booking_presentation_module.dart';
import 'package:tumbas_servis/booking/presentation/ringkasan/state/ringkasan_state.dart';
import 'package:tumbas_servis/booking/presentation/utils/schedule_display.dart';
import 'package:tumbas_servis/catalog/data/di/catalog_data_module.dart';
import 'package:tumbas_servis/core/data/di/core_data_module.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking_draft.dart';
import 'package:tumbas_servis/core/domain/model/catalog/part.dart';
import 'package:tumbas_servis/core/domain/model/catalog/service_type.dart';
import 'package:tumbas_servis/core/domain/model/catalog/voucher.dart';
import 'package:tumbas_servis/core/domain/model/garage/motor.dart';
import 'package:tumbas_servis/core/domain/model/result.dart';
import 'package:tumbas_servis/core/domain/model/workshop/time_slot.dart';
import 'package:tumbas_servis/core/domain/model/workshop/workshop.dart';
import 'package:tumbas_servis/core/domain/service/scheduling/slot_capacity_service.dart';
import 'package:tumbas_servis/core/presentation/utils/time_formatter.dart';
import 'package:tumbas_servis/garage/data/di/garage_data_module.dart';
import 'package:tumbas_servis/workshop/data/di/workshop_data_module.dart';

const _confirmErrorMessage =
    'Booking belum terkirim — periksa koneksi lalu coba lagi.';

T? _find<T>(Iterable<T> items, bool Function(T) test) {
  for (final item in items) {
    if (test(item)) return item;
  }
  return null;
}

class RingkasanViewModel extends Notifier<RingkasanState> {
  static const _capacityService = SlotCapacityService();

  List<Voucher> _vouchers = [];

  @override
  RingkasanState build() => const RingkasanState();

  Future<BookingDraft?> _waitForDraft() async {
    for (var i = 0; i < 200; i++) {
      final draft = ref.read(bookingDraftProvider);
      if (draft != null) return draft;
      await Future<void>.delayed(const Duration(milliseconds: 5));
    }
    return null;
  }

  Future<void> reload() async {
    state = state.copyWith(
      isLoading: true,
      hasError: false,
      confirmError: null,
      confirmedBookingId: null,
    );
    await _load();
  }

  Future<void> _load() async {
    final draft = await _waitForDraft();
    if (!ref.mounted) return;
    final workshopId = draft?.workshopId;
    if (draft == null || workshopId == null || draft.selectedMotorIds.isEmpty) {
      state = state.copyWith(isLoading: false, hasError: true);
      return;
    }

    final workshopResult = await ref
        .read(workshopRepositoryProvider)
        .getWorkshop(workshopId);
    if (!ref.mounted) return;
    if (workshopResult is Error<Workshop>) {
      state = state.copyWith(isLoading: false, hasError: true);
      return;
    }

    final motorsResult = await ref.read(garageRepositoryProvider).getMotors();
    if (!ref.mounted) return;
    if (motorsResult is Error<List<Motor>>) {
      state = state.copyWith(isLoading: false, hasError: true);
      return;
    }

    final catalogRepo = ref.read(catalogRepositoryProvider);
    final serviceTypesResult = await catalogRepo.getServiceTypes();
    if (!ref.mounted) return;
    if (serviceTypesResult is Error<List<ServiceType>>) {
      state = state.copyWith(isLoading: false, hasError: true);
      return;
    }
    final partsResult = await catalogRepo.getParts();
    if (!ref.mounted) return;
    if (partsResult is Error<List<Part>>) {
      state = state.copyWith(isLoading: false, hasError: true);
      return;
    }

    final vouchersResult = await catalogRepo.getVouchers();
    if (!ref.mounted) return;
    _vouchers = vouchersResult is Ok<List<Voucher>> ? vouchersResult.value : [];
    final voucher = draft.voucherId == null
        ? null
        : _find(_vouchers, (v) => v.id == draft.voucherId);

    final workshop = (workshopResult as Ok<Workshop>).value;
    final invalid = await _checkSlotInvalid(draft: draft, workshop: workshop);

    state = state.copyWith(
      isLoading: false,
      hasError: false,
      workshop: workshop,
      motorsById: {
        for (final m in (motorsResult as Ok<List<Motor>>).value) m.id: m,
      },
      serviceById: {
        for (final s in (serviceTypesResult as Ok<List<ServiceType>>).value)
          s.id: s,
      },
      partById: {
        for (final p in (partsResult as Ok<List<Part>>).value) p.id: p,
      },
      voucher: voucher,
      removedVoucherId: null,
      slotInvalid: invalid != null,
      slotInvalidTitle: invalid?.$1,
      slotInvalidBody: invalid?.$2,
    );
  }

  Future<(String, String)?> _checkSlotInvalid({
    required BookingDraft draft,
    required Workshop workshop,
  }) async {
    if (draft.scheduleMode != ScheduleMode.shared) return null;
    final sharedSlot = draft.sharedSlot;
    if (sharedSlot == null) return null;

    final result = await ref
        .read(workshopRepositoryProvider)
        .getAvailableSlots(workshopId: workshop.id, date: sharedSlot.date);
    if (result is! Ok<List<TimeSlot>>) return null;
    final fresh = _find(result.value, (s) => s.hour == sharedSlot.hour);
    if (fresh == null) return null;

    final unitCount = draft.selectedMotorIds.length;
    if (_capacityService.hasSharedCapacityFor(
      slot: fresh,
      unitCount: unitCount,
    )) {
      return null;
    }

    final hourLabel = TimeFormatter.format(slotDateTime(fresh));
    return (
      'Jam $hourLabel sudah tidak muat $unitCount motor',
      'Tersisa ${fresh.remaining} motor di ${slotRecapLabel(fresh)}. '
          'Pisah jadwal atau pilih jam lain.',
    );
  }

  void toggleAccordion(String motorId) {
    final expanded = {...state.expandedMotorIds};
    if (!expanded.remove(motorId)) expanded.add(motorId);
    state = state.copyWith(expandedMotorIds: expanded);
  }

  Future<void> removeVoucher() async {
    final voucher = state.voucher;
    if (voucher == null) return;
    state = state.copyWith(voucher: null, removedVoucherId: voucher.id);
    await ref.read(bookingDraftProvider.notifier).setVoucher(null);
  }

  Future<void> undoRemoveVoucher() async {
    final voucherId = state.removedVoucherId;
    if (voucherId == null) return;
    final voucher = _find(_vouchers, (v) => v.id == voucherId);
    state = state.copyWith(voucher: voucher, removedVoucherId: null);
    await ref.read(bookingDraftProvider.notifier).setVoucher(voucherId);
  }

  Future<void> confirm() async {
    final draft = ref.read(bookingDraftProvider);
    if (draft == null || state.slotInvalid || state.confirming) return;

    state = state.copyWith(confirming: true, confirmError: null);

    if (ref.read(demoModeControllerProvider).consumeArmedError()) {
      state = state.copyWith(
        confirming: false,
        confirmError: _confirmErrorMessage,
      );
      return;
    }

    final result = await ref
        .read(bookingRepositoryProvider)
        .confirmBooking(draft);
    if (!ref.mounted) return;

    if (result is Error<Booking>) {
      state = state.copyWith(
        confirming: false,
        confirmError: _confirmErrorMessage,
      );
      return;
    }

    state = state.copyWith(
      confirming: false,
      confirmedBookingId: (result as Ok<Booking>).value.id,
    );
  }
}
