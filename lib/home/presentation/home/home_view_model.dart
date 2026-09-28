import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tumbas_servis/auth/data/di/auth_data_module.dart';
import 'package:tumbas_servis/booking/data/di/booking_data_module.dart';
import 'package:tumbas_servis/catalog/data/di/catalog_data_module.dart';
import 'package:tumbas_servis/core/data/di/core_data_module.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking_draft.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking_status.dart';
import 'package:tumbas_servis/core/domain/model/catalog/promo.dart';
import 'package:tumbas_servis/core/domain/model/garage/motor.dart';
import 'package:tumbas_servis/core/domain/model/result.dart';
import 'package:tumbas_servis/core/domain/model/user/user.dart';
import 'package:tumbas_servis/core/domain/model/workshop/workshop.dart';
import 'package:tumbas_servis/garage/data/di/garage_data_module.dart';
import 'package:tumbas_servis/home/presentation/di/home_presentation_module.dart';
import 'package:tumbas_servis/home/presentation/home/state/home_state.dart';
import 'package:tumbas_servis/home/presentation/utils/home_booking_display.dart';
import 'package:tumbas_servis/home/presentation/utils/home_draft_display.dart';
import 'package:tumbas_servis/notification/data/di/notification_data_module.dart';
import 'package:tumbas_servis/workshop/data/di/workshop_data_module.dart';

class HomeViewModel extends Notifier<HomeState> {
  StreamSubscription<int>? _unreadSubscription;

  @override
  HomeState build() {
    ref.onDispose(() => _unreadSubscription?.cancel());
    _load();
    return const HomeState();
  }

  Future<void> refresh() async {
    state = state.copyWith(isLoading: true, hasError: false);
    await _load();
  }

  Future<void> _load() async {
    await ref.read(demoContentSeederProvider).seedIfNeeded();

    final userResult = await ref.read(sessionRepositoryProvider).currentUser();
    final motorsResult = await ref.read(garageRepositoryProvider).getMotors();
    final promosResult = await ref.read(catalogRepositoryProvider).getPromos();
    final bookingsResult = await ref
        .read(bookingRepositoryProvider)
        .getBookings(status: BookingStatus.berlangsung);
    final draftResult = await ref
        .read(bookingRepositoryProvider)
        .getCurrentDraft();
    final workshopsResult = await ref
        .read(workshopRepositoryProvider)
        .getWorkshops();

    if (!ref.mounted) return;

    if (userResult is Error<User?> ||
        motorsResult is Error<List<Motor>> ||
        promosResult is Error<List<Promo>> ||
        bookingsResult is Error<List<Booking>> ||
        draftResult is Error<BookingDraft?> ||
        workshopsResult is Error<List<Workshop>>) {
      state = state.copyWith(isLoading: false, hasError: true);
      return;
    }

    final user = (userResult as Ok<User?>).value;
    final motors = (motorsResult as Ok<List<Motor>>).value;
    final promos = (promosResult as Ok<List<Promo>>).value;
    final bookings = (bookingsResult as Ok<List<Booking>>).value;
    final draft = (draftResult as Ok<BookingDraft?>).value;
    final workshops = (workshopsResult as Ok<List<Workshop>>).value;
    final workshopNameById = {for (final w in workshops) w.id: w.name};

    state = state.copyWith(
      isLoading: false,
      hasError: false,
      userName: user?.name ?? '',
      motors: motors,
      motorInServiceStatus: bookings.motorInServiceStatus,
      activeBookings: bookings
          .take(2)
          .map((b) => b.toActiveBookingDisplay(workshopNameById))
          .toList(),
      activeBookingsTotalCount: bookings.length,
      draft: draft?.toHomeDraftDisplay(motors, ref.read(clockProvider).now()),
      promos: promos,
    );

    _unreadSubscription?.cancel();
    _unreadSubscription = ref
        .read(notificationRepositoryProvider)
        .watchUnreadCount()
        .listen((count) {
          if (ref.mounted) state = state.copyWith(unreadCount: count);
        });
  }

  Future<void> deleteDraft() async {
    if (state.draft == null) return;
    await ref.read(bookingRepositoryProvider).deleteDraft();
    if (ref.mounted) state = state.copyWith(draft: null);
  }
}
