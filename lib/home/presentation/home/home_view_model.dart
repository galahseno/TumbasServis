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

const _seedShare = 0.6;

class HomeViewModel extends Notifier<HomeState> {
  StreamSubscription<int>? _unreadSubscription;

  @override
  HomeState build() {
    ref.onDispose(() => _unreadSubscription?.cancel());
    _load();
    return const HomeState();
  }

  Future<void> refresh() async {
    state = state.copyWith(
      isLoading: true,
      hasError: false,
      isFirstLoad: false,
      loadProgress: 0,
    );
    await _load();
  }

  void _reportProgress(double fraction, String label) {
    if (!ref.mounted) return;
    state = state.copyWith(
      loadProgress: fraction > state.loadProgress
          ? fraction.clamp(0.0, 1.0)
          : state.loadProgress,
      loadLabel: label,
    );
  }

  Future<void> _load() async {
    await Future<void>.value();
    if (!ref.mounted) return;

    var didSeed = false;
    await ref
        .read(demoContentSeederProvider)
        .seedIfNeeded(
          onProgress: (fraction, label) {
            didSeed = true;
            _reportProgress(fraction * _seedShare, label);
          },
        );
    if (!ref.mounted) return;

    final readsBase = didSeed ? _seedShare : 0.0;
    final pending = <String>[
      'Memuat akun…',
      'Memuat garasi…',
      'Memuat promo…',
      'Memuat booking…',
      'Memuat draft…',
      'Memuat bengkel…',
    ];
    final total = pending.length;
    var done = 0;
    Future<T> track<T>(String label, Future<T> read) async {
      final result = await read;
      pending.remove(label);
      done++;
      _reportProgress(
        readsBase + (1 - readsBase) * done / total,
        pending.isEmpty ? 'Hampir selesai…' : pending.first,
      );
      return result;
    }

    _reportProgress(readsBase, pending.first);
    final (
      userResult,
      motorsResult,
      promosResult,
      bookingsResult,
      draftResult,
      workshopsResult,
    ) = await (
      track(pending[0], ref.read(sessionRepositoryProvider).currentUser()),
      track(pending[1], ref.read(garageRepositoryProvider).getMotors()),
      track(pending[2], ref.read(catalogRepositoryProvider).getPromos()),
      track(
        pending[3],
        ref
            .read(bookingRepositoryProvider)
            .getBookings(status: BookingStatus.berlangsung),
      ),
      track(pending[4], ref.read(bookingRepositoryProvider).getCurrentDraft()),
      track(pending[5], ref.read(workshopRepositoryProvider).getWorkshops()),
    ).wait;

    if (!ref.mounted) return;

    if (userResult is Error<User?> ||
        motorsResult is Error<List<Motor>> ||
        promosResult is Error<List<Promo>> ||
        bookingsResult is Error<List<Booking>> ||
        draftResult is Error<BookingDraft?> ||
        workshopsResult is Error<List<Workshop>>) {
      state = state.copyWith(
        isLoading: false,
        hasError: true,
        isFirstLoad: false,
      );
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
      isFirstLoad: false,
      loadProgress: 1,
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
