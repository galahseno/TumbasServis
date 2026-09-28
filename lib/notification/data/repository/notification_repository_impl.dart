// ignore_for_file: prefer_initializing_formals
import 'dart:async';

import 'package:tumbas_servis/core/data/service/latency_simulator.dart';
import 'package:tumbas_servis/core/data/service/local_store.dart';
import 'package:tumbas_servis/core/data/service/mock_json_loader.dart';
import 'package:tumbas_servis/core/domain/model/notification/app_notification.dart';
import 'package:tumbas_servis/core/domain/model/result.dart';
import 'package:tumbas_servis/core/domain/repository/notification/notification_repository.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  NotificationRepositoryImpl({
    required LocalStore localStore,
    required MockJsonLoader mockJsonLoader,
    required LatencySimulator latencySimulator,
  }) : _localStore = localStore,
       _mockJsonLoader = mockJsonLoader,
       _latencySimulator = latencySimulator;

  final LocalStore _localStore;
  final MockJsonLoader _mockJsonLoader;
  final LatencySimulator _latencySimulator;

  final _unreadCountController = StreamController<int>.broadcast();

  static const _notificationsBox = 'notifications';

  @override
  Future<Result<List<AppNotification>>> getNotifications() async {
    try {
      await _latencySimulator.simulate();
      await _ensureSeeded();
      final rows = await _localStore.getAll(_notificationsBox);
      final notifications = rows.map(_notificationFromJson).toList()
        ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
      return Result.ok(notifications);
    } catch (e) {
      return Result.error(e is Exception ? e : Exception(e.toString()));
    }
  }

  @override
  Future<Result<void>> markRead(String id) async {
    try {
      await _latencySimulator.simulate();
      await _ensureSeeded();
      final row = await _localStore.get(_notificationsBox, id);
      if (row == null) {
        return Result.error(Exception('Notifikasi tidak ditemukan: $id'));
      }
      row['read'] = true;
      await _localStore.put(_notificationsBox, id, row);
      await _pushUnreadCount();
      return const Result.ok(null);
    } catch (e) {
      return Result.error(e is Exception ? e : Exception(e.toString()));
    }
  }

  @override
  Future<Result<void>> addNotification(AppNotification notification) async {
    try {
      await _latencySimulator.simulate();
      await _ensureSeeded();
      await _localStore.put(
        _notificationsBox,
        notification.id,
        _notificationToJson(notification),
      );
      await _pushUnreadCount();
      return const Result.ok(null);
    } catch (e) {
      return Result.error(e is Exception ? e : Exception(e.toString()));
    }
  }

  @override
  Stream<int> watchUnreadCount() async* {
    yield await _computeUnreadCount();
    yield* _unreadCountController.stream;
  }

  Future<void> _pushUnreadCount() async {
    _unreadCountController.add(await _computeUnreadCount());
  }

  Future<int> _computeUnreadCount() async {
    await _ensureSeeded();
    final rows = await _localStore.getAll(_notificationsBox);
    return rows.where((row) => row['read'] != true).length;
  }

  Future<void> _ensureSeeded() async {
    final existing = await _localStore.getAll(_notificationsBox);
    if (existing.isNotEmpty) return;
    final json =
        await _mockJsonLoader.load('notifications_seed.json') as List<dynamic>;
    for (final row in json.cast<Map<String, dynamic>>()) {
      await _localStore.put(_notificationsBox, row['id'] as String, row);
    }
  }

  AppNotification _notificationFromJson(Map<String, dynamic> json) =>
      AppNotification(
        id: json['id'] as String,
        category: NotificationCategoryX.fromString(json['category'] as String?),
        title: json['title'] as String,
        body: json['body'] as String,
        timestamp: DateTime.parse(json['timestamp'] as String),
        read: json['read'] as bool,
        deepLink: json['deep_link'] as String?,
      );

  Map<String, dynamic> _notificationToJson(AppNotification notification) => {
    'id': notification.id,
    'category': notification.category.name,
    'title': notification.title,
    'body': notification.body,
    'timestamp': notification.timestamp.toIso8601String(),
    'read': notification.read,
    'deep_link': notification.deepLink,
  };
}
