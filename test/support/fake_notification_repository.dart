import 'dart:async';

import 'package:tumbas_servis/core/domain/model/notification/app_notification.dart';
import 'package:tumbas_servis/core/domain/model/result.dart';
import 'package:tumbas_servis/core/domain/repository/notification/notification_repository.dart';

class FakeNotificationRepository implements NotificationRepository {
  FakeNotificationRepository({List<AppNotification>? notifications})
    : notifications = notifications ?? [];

  int _staticUnread = 0;
  final List<AppNotification> notifications;
  final StreamController<int> _unread = StreamController<int>.broadcast();

  bool failGet = false;
  bool failMarkAll = false;
  Duration delay = Duration.zero;
  final List<String> markReadCalls = [];
  int markAllReadCalls = 0;

  set unreadCount(int value) => _staticUnread = value;
  int get unreadCount => notifications.isEmpty
      ? _staticUnread
      : notifications.where((n) => !n.read).length;

  @override
  Future<Result<List<AppNotification>>> getNotifications() async {
    if (delay > Duration.zero) await Future<void>.delayed(delay);
    if (failGet) return Result.error(Exception('boom'));
    return Result.ok(List.of(notifications));
  }

  @override
  Future<Result<void>> markRead(String id) async {
    markReadCalls.add(id);
    final index = notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      notifications[index] = notifications[index].copyWith(read: true);
      _unread.add(unreadCount);
    }
    return const Result.ok(null);
  }

  @override
  Future<Result<void>> markAllRead() async {
    markAllReadCalls++;
    if (failMarkAll) return Result.error(Exception('boom'));
    for (var i = 0; i < notifications.length; i++) {
      notifications[i] = notifications[i].copyWith(read: true);
    }
    _unread.add(unreadCount);
    return const Result.ok(null);
  }

  @override
  Future<Result<void>> addNotification(AppNotification notification) async {
    notifications.add(notification);
    _unread.add(unreadCount);
    return const Result.ok(null);
  }

  @override
  Stream<int> watchUnreadCount() async* {
    yield unreadCount;
    yield* _unread.stream;
  }
}
