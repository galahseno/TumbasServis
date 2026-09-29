import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tumbas_servis/booking/data/di/booking_data_module.dart';
import 'package:tumbas_servis/catalog/data/di/catalog_data_module.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking_unit.dart';
import 'package:tumbas_servis/core/domain/model/catalog/part.dart';
import 'package:tumbas_servis/core/domain/model/catalog/service_type.dart';
import 'package:tumbas_servis/core/domain/model/result.dart';
import 'package:tumbas_servis/core/domain/model/workshop/mechanic.dart';
import 'package:tumbas_servis/tracking/data/di/tracking_data_module.dart';
import 'package:tumbas_servis/tracking/presentation/lacak_unit/state/lacak_unit_state.dart';
import 'package:tumbas_servis/tracking/presentation/utils/tracking_display.dart';
import 'package:tumbas_servis/workshop/data/di/workshop_data_module.dart';

typedef LacakUnitArgs = ({String bookingId, String unitCode});

class LacakUnitViewModel extends Notifier<LacakUnitState> {
  LacakUnitViewModel(this.args);

  final LacakUnitArgs args;

  StreamSubscription<BookingUnit>? _subscription;
  Map<String, Mechanic> _mechanics = const {};

  @override
  LacakUnitState build() {
    ref.onDispose(() => _subscription?.cancel());
    _load();
    return const LacakUnitState();
  }

  Future<void> retry() async {
    state = state.copyWith(isLoading: true, hasError: false);
    await _load();
  }

  Future<void> _load() async {
    final bookingResult = await ref
        .read(bookingRepositoryProvider)
        .getBooking(args.bookingId);
    final mechanicsResult = await ref
        .read(workshopRepositoryProvider)
        .getMechanics();
    final servicesResult = await ref
        .read(catalogRepositoryProvider)
        .getServiceTypes();
    final partsResult = await ref.read(catalogRepositoryProvider).getParts();
    if (!ref.mounted) return;

    if (bookingResult is! Ok<Booking> ||
        servicesResult is! Ok<List<ServiceType>> ||
        partsResult is! Ok<List<Part>>) {
      state = state.copyWith(isLoading: false, hasError: true);
      return;
    }
    final booking = bookingResult.value;
    final unit = booking.units
        .where((u) => u.unitCode == args.unitCode)
        .firstOrNull;
    if (unit == null) {
      state = state.copyWith(isLoading: false, hasError: true);
      return;
    }

    _mechanics = switch (mechanicsResult) {
      Ok<List<Mechanic>>(:final value) => {for (final m in value) m.id: m},
      Error<List<Mechanic>>() => const {},
    };

    final summary = unitServicesSummary(
      unit,
      serviceNameById: {for (final s in servicesResult.value) s.id: s.name},
      partCategoryById: {for (final p in partsResult.value) p.id: p.category},
    );

    state = state.copyWith(
      isLoading: false,
      hasError: false,
      booking: booking,
      unit: unit,
      mechanic: _mechanics[unit.mechanicId],
      servicesSummary: summary,
    );

    _subscription?.cancel();
    _subscription = ref
        .read(trackingRepositoryProvider)
        .watchUnitStatus(bookingId: args.bookingId, unitCode: args.unitCode)
        .listen(_onUnit);
  }

  void _onUnit(BookingUnit updated) {
    if (!ref.mounted) return;
    state = state.copyWith(
      unit: updated,
      mechanic: _mechanics[updated.mechanicId],
    );
  }

  Future<bool> advance() => _demo(
    () => ref
        .read(trackingRepositoryProvider)
        .advanceUnitStatus(bookingId: args.bookingId, unitCode: args.unitCode),
  );

  Future<bool> reset() => _demo(
    () => ref
        .read(trackingRepositoryProvider)
        .resetUnitStatus(bookingId: args.bookingId, unitCode: args.unitCode),
  );

  Future<bool> _demo(Future<Result<void>> Function() action) async {
    if (state.isDemoBusy) return false;
    state = state.copyWith(isDemoBusy: true);
    final result = await action();
    if (!ref.mounted) return false;
    state = state.copyWith(isDemoBusy: false);
    return result is Ok<void>;
  }
}
