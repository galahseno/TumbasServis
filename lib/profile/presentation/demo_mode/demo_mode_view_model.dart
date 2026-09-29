import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tumbas_servis/booking/data/di/booking_data_module.dart';
import 'package:tumbas_servis/booking/presentation/di/booking_presentation_module.dart';
import 'package:tumbas_servis/core/data/di/core_data_module.dart';
import 'package:tumbas_servis/core/data/service/demo_mode_controller.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking_status.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking_unit.dart';
import 'package:tumbas_servis/core/domain/model/booking/unit_status.dart';
import 'package:tumbas_servis/core/domain/model/result.dart';
import 'package:tumbas_servis/garage/presentation/di/garage_presentation_module.dart';
import 'package:tumbas_servis/home/presentation/di/home_presentation_module.dart';
import 'package:tumbas_servis/notification/presentation/di/notification_presentation_module.dart';
import 'package:tumbas_servis/profile/presentation/demo_mode/state/demo_mode_state.dart';
import 'package:tumbas_servis/tracking/data/di/tracking_data_module.dart';
import 'package:tumbas_servis/tracking/presentation/di/tracking_presentation_module.dart';

class DemoModeViewModel extends Notifier<DemoModeState> {
  StreamSubscription<bool>? _armedSubscription;
  final Map<String, StreamSubscription<BookingUnit>> _unitSubscriptions = {};

  @override
  DemoModeState build() {
    final controller = ref.read(demoModeControllerProvider);
    _armedSubscription = controller.armedChanges.listen((armed) {
      if (ref.mounted) state = state.copyWith(errorArmed: armed);
    });
    ref.onDispose(() {
      _armedSubscription?.cancel();
      _cancelUnitSubscriptions();
    });
    _load();
    return DemoModeState(
      speed: controller.trackingSpeed,
      errorArmed: controller.isErrorArmed,
    );
  }

  Future<void> retry() async {
    state = state.copyWith(isLoading: true, hasError: false);
    await _load();
  }

  Future<void> _load() async {
    final result = await ref
        .read(bookingRepositoryProvider)
        .getBookings(status: BookingStatus.berlangsung);
    if (!ref.mounted) return;
    if (result is! Ok<List<Booking>>) {
      state = state.copyWith(isLoading: false, hasError: true);
      return;
    }
    final booking = result.value.firstOrNull;
    _watchUnits(booking);
    state = state.copyWith(
      isLoading: false,
      hasError: false,
      bookingId: booking?.id,
      bookingCode: booking?.code ?? '',
      units: booking?.units ?? const [],
    );
  }

  void _watchUnits(Booking? booking) {
    _cancelUnitSubscriptions();
    if (booking == null) return;
    for (final unit in booking.units) {
      _unitSubscriptions[unit.unitCode] = ref
          .read(trackingRepositoryProvider)
          .watchUnitStatus(bookingId: booking.id, unitCode: unit.unitCode)
          .listen(_onUnit);
    }
  }

  void _cancelUnitSubscriptions() {
    for (final subscription in _unitSubscriptions.values) {
      subscription.cancel();
    }
    _unitSubscriptions.clear();
  }

  void _onUnit(BookingUnit updated) {
    if (!ref.mounted) return;
    state = state.copyWith(
      units: [
        for (final unit in state.units)
          if (unit.unitCode == updated.unitCode)
            unit.copyWith(
              status: updated.status,
              statusHistory: updated.statusHistory,
            )
          else
            unit,
      ],
    );
  }

  void setSpeed(TrackingSpeed speed) {
    ref.read(demoModeControllerProvider).setTrackingSpeed(speed);
    state = state.copyWith(speed: speed);
  }

  void setErrorArmed(bool armed) {
    final controller = ref.read(demoModeControllerProvider);
    if (armed) {
      controller.armNextWriteError();
    } else {
      controller.disarmError();
    }
  }

  Future<bool> advanceUnit(String unitCode) =>
      _runBusy(() => _advance(unitCode));

  Future<bool> resetUnit(String unitCode) => _runBusy(() => _reset(unitCode));

  Future<bool> advanceAll() => _runBusy(() async {
    var ok = true;
    for (final unit in state.units.where((u) => !u.status.isTerminal)) {
      ok = await _advance(unit.unitCode) && ok;
    }
    return ok;
  });

  Future<bool> resetAll() => _runBusy(() async {
    var ok = true;
    for (final unit in List.of(state.units)) {
      ok = await _reset(unit.unitCode) && ok;
    }
    return ok;
  });

  Future<bool> _advance(String unitCode) async {
    final result = await ref
        .read(trackingRepositoryProvider)
        .advanceUnitStatus(bookingId: state.bookingId!, unitCode: unitCode);
    return result is Ok<void>;
  }

  Future<bool> _reset(String unitCode) async {
    final result = await ref
        .read(trackingRepositoryProvider)
        .resetUnitStatus(bookingId: state.bookingId!, unitCode: unitCode);
    return result is Ok<void>;
  }

  Future<bool> _runBusy(Future<bool> Function() action) async {
    if (state.isBusy || state.isResetting || !state.hasActiveBooking) {
      return false;
    }
    state = state.copyWith(isBusy: true);
    final ok = await action();
    if (ref.mounted) state = state.copyWith(isBusy: false);
    return ok;
  }

  Future<bool> resetAllData() async {
    if (state.isBusy || state.isResetting) return false;
    state = state.copyWith(isResetting: true);
    try {
      await ref.read(demoResetServiceProvider).reset();
      await ref.read(demoContentSeederProvider).seedIfNeeded();
    } on Object {
      if (ref.mounted) state = state.copyWith(isResetting: false);
      return false;
    }

    ref
      ..invalidate(homeViewModelProvider)
      ..invalidate(garasiViewModelProvider)
      ..invalidate(riwayatViewModelProvider)
      ..invalidate(bookingDraftProvider)
      ..invalidate(notifikasiViewModelProvider);
    if (ref.mounted) await _load();
    if (ref.mounted) state = state.copyWith(isResetting: false);
    return true;
  }
}
