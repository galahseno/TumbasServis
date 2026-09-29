import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tumbas_servis/booking/data/di/booking_data_module.dart';
import 'package:tumbas_servis/booking/presentation/tiket/state/tiket_state.dart';
import 'package:tumbas_servis/catalog/data/di/catalog_data_module.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking.dart';
import 'package:tumbas_servis/core/domain/model/catalog/service_type.dart';
import 'package:tumbas_servis/core/domain/model/result.dart';
import 'package:tumbas_servis/core/domain/model/workshop/workshop.dart';
import 'package:tumbas_servis/workshop/data/di/workshop_data_module.dart';

class TiketViewModel extends Notifier<TiketState> {
  @override
  TiketState build() => const TiketState();

  Future<void> load(String bookingId) async {
    state = state.copyWith(isLoading: true, hasError: false);

    final bookingResult = await ref
        .read(bookingRepositoryProvider)
        .getBooking(bookingId);
    if (!ref.mounted) return;
    if (bookingResult is Error<Booking>) {
      state = state.copyWith(isLoading: false, hasError: true);
      return;
    }
    final booking = (bookingResult as Ok<Booking>).value;

    final workshopResult = await ref
        .read(workshopRepositoryProvider)
        .getWorkshop(booking.workshopId);
    if (!ref.mounted) return;
    if (workshopResult is Error<Workshop>) {
      state = state.copyWith(isLoading: false, hasError: true);
      return;
    }

    final serviceTypesResult = await ref
        .read(catalogRepositoryProvider)
        .getServiceTypes();
    if (!ref.mounted) return;
    if (serviceTypesResult is Error<List<ServiceType>>) {
      state = state.copyWith(isLoading: false, hasError: true);
      return;
    }

    state = state.copyWith(
      isLoading: false,
      hasError: false,
      booking: booking,
      workshop: (workshopResult as Ok<Workshop>).value,
      serviceById: {
        for (final s in (serviceTypesResult as Ok<List<ServiceType>>).value)
          s.id: s,
      },
    );
  }

  Future<void> copyCode() async {
    final code = state.booking?.code;
    if (code == null) return;
    await Clipboard.setData(ClipboardData(text: code));
    if (!ref.mounted) return;
    state = state.copyWith(copyCount: state.copyCount + 1);
  }
}
