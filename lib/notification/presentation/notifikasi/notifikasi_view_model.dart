import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tumbas_servis/booking/data/di/booking_data_module.dart';
import 'package:tumbas_servis/core/data/di/core_data_module.dart';
import 'package:tumbas_servis/core/domain/model/notification/app_notification.dart';
import 'package:tumbas_servis/core/domain/model/result.dart';
import 'package:tumbas_servis/notification/data/di/notification_data_module.dart';
import 'package:tumbas_servis/notification/presentation/notifikasi/state/notifikasi_state.dart';
import 'package:tumbas_servis/notification/presentation/utils/notification_deep_link_resolver.dart';

class NotifikasiViewModel extends Notifier<NotifikasiState> {
  StreamSubscription<int>? _unreadSubscription;

  @override
  NotifikasiState build() {
    ref.onDispose(() => _unreadSubscription?.cancel());
    _load();
    return const NotifikasiState();
  }

  Future<void> retry() async {
    state = state.copyWith(isLoading: true, hasError: false);
    await _load();
  }

  Future<void> refresh() => _load();

  Future<void> _load() async {
    final result = await ref
        .read(notificationRepositoryProvider)
        .getNotifications();
    if (!ref.mounted) return;
    if (result is! Ok<List<AppNotification>>) {
      state = state.copyWith(isLoading: false, hasError: true);
      return;
    }
    state = state.copyWith(
      isLoading: false,
      hasError: false,
      notifications: result.value,
      now: ref.read(clockProvider).now(),
    );
    _unreadSubscription ??= ref
        .read(notificationRepositoryProvider)
        .watchUnreadCount()
        .skip(1)
        .listen((_) {
          if (ref.mounted) unawaited(_reload());
        });
  }

  Future<void> _reload() async {
    final result = await ref
        .read(notificationRepositoryProvider)
        .getNotifications();
    if (!ref.mounted || result is! Ok<List<AppNotification>>) return;
    state = state.copyWith(
      notifications: result.value,
      now: ref.read(clockProvider).now(),
    );
  }

  Future<NotificationTarget?> open(AppNotification notification) async {
    if (!notification.read) {
      state = state.copyWith(
        notifications: [
          for (final n in state.notifications)
            if (n.id == notification.id) n.copyWith(read: true) else n,
        ],
      );
      await ref.read(notificationRepositoryProvider).markRead(notification.id);
    }
    if (!ref.mounted) return null;
    return NotificationDeepLinkResolver(
      bookingRepository: ref.read(bookingRepositoryProvider),
    ).resolve(notification.deepLink);
  }

  Future<bool> markAllRead() async {
    if (state.isMarkingAll || state.unreadCount == 0) return false;
    state = state.copyWith(isMarkingAll: true);
    final result = await ref.read(notificationRepositoryProvider).markAllRead();
    if (!ref.mounted) return false;
    if (result is! Ok<void>) {
      state = state.copyWith(isMarkingAll: false);
      return false;
    }
    state = state.copyWith(
      isMarkingAll: false,
      notifications: [
        for (final n in state.notifications) n.copyWith(read: true),
      ],
    );
    return true;
  }
}
