import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tumbas_servis/booking/data/di/booking_data_module.dart';
import 'package:tumbas_servis/catalog/data/di/catalog_data_module.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking_unit.dart';
import 'package:tumbas_servis/core/domain/model/booking/unit_status.dart';
import 'package:tumbas_servis/core/domain/model/catalog/part.dart';
import 'package:tumbas_servis/core/domain/model/catalog/service_type.dart';
import 'package:tumbas_servis/core/domain/model/invoice/invoice.dart';
import 'package:tumbas_servis/core/domain/model/result.dart';
import 'package:tumbas_servis/core/domain/model/review/review.dart';
import 'package:tumbas_servis/core/domain/model/workshop/workshop.dart';
import 'package:tumbas_servis/core/domain/service/status/booking_status_derivation.dart';
import 'package:tumbas_servis/invoice/data/di/invoice_data_module.dart';
import 'package:tumbas_servis/review/data/di/review_data_module.dart';
import 'package:tumbas_servis/tracking/data/di/tracking_data_module.dart';
import 'package:tumbas_servis/tracking/presentation/detail_booking/state/detail_booking_state.dart';
import 'package:tumbas_servis/tracking/presentation/utils/tracking_display.dart';
import 'package:tumbas_servis/workshop/data/di/workshop_data_module.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking_status.dart';

class DetailBookingViewModel extends Notifier<DetailBookingState> {
  DetailBookingViewModel(this.bookingId);

  final String bookingId;

  static const _derivation = BookingStatusDerivation();

  final Map<String, StreamSubscription<BookingUnit>> _subscriptions = {};

  @override
  DetailBookingState build() {
    ref.onDispose(_cancelSubscriptions);
    _load();
    return const DetailBookingState();
  }

  Future<void> retry() async {
    state = state.copyWith(isLoading: true, hasError: false);
    await _load();
  }

  Future<void> refresh() => _load();

  void _cancelSubscriptions() {
    for (final subscription in _subscriptions.values) {
      subscription.cancel();
    }
    _subscriptions.clear();
  }

  Future<void> _load() async {
    final bookingResult = await ref
        .read(bookingRepositoryProvider)
        .getBooking(bookingId);
    if (!ref.mounted) return;
    if (bookingResult is! Ok<Booking>) {
      state = state.copyWith(isLoading: false, hasError: true);
      return;
    }
    final booking = bookingResult.value;

    final workshopResult = await ref
        .read(workshopRepositoryProvider)
        .getWorkshop(booking.workshopId);
    final servicesResult = await ref
        .read(catalogRepositoryProvider)
        .getServiceTypes();
    final partsResult = await ref.read(catalogRepositoryProvider).getParts();
    if (!ref.mounted) return;
    if (workshopResult is! Ok<Workshop> ||
        servicesResult is! Ok<List<ServiceType>> ||
        partsResult is! Ok<List<Part>>) {
      state = state.copyWith(isLoading: false, hasError: true);
      return;
    }

    final serviceNames = {for (final s in servicesResult.value) s.id: s.name};
    final partCategories = {
      for (final p in partsResult.value) p.id: p.category,
    };
    final unitMeta = {
      for (final unit in booking.units)
        unit.unitCode: unitMetaLine(
          unit,
          serviceNameById: serviceNames,
          partCategoryById: partCategories,
        ),
    };

    state = state.copyWith(
      isLoading: false,
      hasError: false,
      booking: booking,
      workshopName: workshopResult.value.name,
      bayCount: workshopResult.value.bayCount,
      unitMeta: unitMeta,
    );
    _watchUnits(booking);
    if (booking.status == BookingStatus.selesai) await _loadFinished();
  }

  Future<void> _loadFinished() async {
    final invoiceResult = await ref
        .read(invoiceRepositoryProvider)
        .getInvoice(bookingId);
    final reviewResult = await ref
        .read(reviewRepositoryProvider)
        .getReview(bookingId);
    if (!ref.mounted) return;
    state = state.copyWith(
      invoicePaid: invoiceResult is Ok<Invoice> && invoiceResult.value.isPaid,
      hasReview: reviewResult is Ok<Review?> && reviewResult.value != null,
    );
  }

  void _watchUnits(Booking booking) {
    final tracking = ref.read(trackingRepositoryProvider);
    final live = {
      for (final unit in booking.units)
        if (!unit.status.isTerminal) unit.unitCode,
    };
    for (final code in _subscriptions.keys.toList()) {
      if (!live.contains(code)) _subscriptions.remove(code)?.cancel();
    }
    for (final code in live) {
      if (_subscriptions.containsKey(code)) continue;
      _subscriptions[code] = tracking
          .watchUnitStatus(bookingId: bookingId, unitCode: code)
          .listen(_onUnit);
    }
  }

  void _onUnit(BookingUnit updated) {
    final booking = state.booking;
    if (booking == null || !ref.mounted) return;
    final units = [
      for (final unit in booking.units)
        unit.unitCode == updated.unitCode ? updated : unit,
    ];
    final derived = _derivation.deriveStatus([for (final u in units) u.status]);
    final wasFinished = booking.status == BookingStatus.selesai;
    state = state.copyWith(
      booking: booking.copyWith(units: units, status: derived),
    );
    if (updated.status.isTerminal) {
      _subscriptions.remove(updated.unitCode)?.cancel();
    }
    if (derived == BookingStatus.selesai && !wasFinished) {
      unawaited(_loadFinished());
    }
  }

  Future<bool> cancel({String? unitCode, String? reason}) async {
    state = state.copyWith(isMutating: true);
    final result = await ref
        .read(bookingRepositoryProvider)
        .cancelBooking(bookingId, unitCode: unitCode, reason: reason);
    if (!ref.mounted) return false;
    if (result is Ok<void>) {
      await _load();
      if (ref.mounted) state = state.copyWith(isMutating: false);
      return true;
    }
    state = state.copyWith(isMutating: false);
    return false;
  }
}
