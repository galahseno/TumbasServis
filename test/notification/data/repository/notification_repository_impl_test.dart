import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive_ce.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tumbas_servis/core/data/service/local_store.dart';
import 'package:tumbas_servis/core/data/service/mock_json_loader.dart';
import 'package:tumbas_servis/core/domain/model/notification/app_notification.dart';
import 'package:tumbas_servis/core/domain/model/result.dart';
import 'package:tumbas_servis/notification/data/repository/notification_repository_impl.dart';

import '../../../support/fake_clock.dart';
import '../../../support/fake_latency_simulator.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory tempDir;
  late NotificationRepositoryImpl repository;
  late LocalStore localStore;
  late FakeClock clock;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    tempDir = Directory.systemTemp.createTempSync('notification_repo_test');
    localStore = LocalStore(
      preferences: await SharedPreferences.getInstance(),
      resolveStorageDirectory: () async => tempDir.path,
    );
    clock = FakeClock(NotificationRepositoryImpl.seedAnchor);
    repository = NotificationRepositoryImpl(
      localStore: localStore,
      mockJsonLoader: MockJsonLoader(),
      latencySimulator: FakeLatencySimulator(),
      clock: clock,
    );
  });

  tearDown(() async {
    await Hive.close();
    tempDir.deleteSync(recursive: true);
  });

  test(
    'getNotifications seeds from notifications_seed.json, sorted newest first',
    () async {
      final result = await repository.getNotifications();
      expect(result, isA<Ok<List<AppNotification>>>());
      final notifications = (result as Ok<List<AppNotification>>).value;
      expect(notifications, hasLength(9));
      expect(notifications.first.id, 'notif_001');
      for (var i = 1; i < notifications.length; i++) {
        expect(
          notifications[i - 1].timestamp.isAfter(notifications[i].timestamp) ||
              notifications[i - 1].timestamp.isAtSameMomentAs(
                notifications[i].timestamp,
              ),
          isTrue,
        );
      }
    },
  );

  test('markRead flips read on the seeded id and is idempotent', () async {
    final first = await repository.markRead('notif_001');
    expect(first, isA<Ok<void>>());

    final notifications =
        ((await repository.getNotifications()) as Ok<List<AppNotification>>)
            .value;
    expect(notifications.firstWhere((n) => n.id == 'notif_001').read, isTrue);

    final second = await repository.markRead('notif_001');
    expect(second, isA<Ok<void>>());
  });

  test('markRead errors on an unknown id', () async {
    final result = await repository.markRead('does_not_exist');
    expect(result, isA<Error<void>>());
  });

  test(
    'addNotification persists a new row retrievable via getNotifications',
    () async {
      final notification = AppNotification(
        id: 'notif_test_001',
        category: NotificationCategory.status,
        title: 'Unit sedang diperiksa',
        body: 'Unit -A sedang diperiksa.',
        timestamp: DateTime(2026, 9, 29, 12),
        read: false,
        deepLink: '/tracking/bk_test/-A',
      );

      final result = await repository.addNotification(notification);
      expect(result, isA<Ok<void>>());

      final notifications =
          ((await repository.getNotifications()) as Ok<List<AppNotification>>)
              .value;
      final stored = notifications.firstWhere((n) => n.id == 'notif_test_001');
      expect(stored.deepLink, '/tracking/bk_test/-A');
    },
  );

  test('watchUnreadCount emits the initial count then live updates', () async {
    Future<void> settle() =>
        Future<void>.delayed(const Duration(milliseconds: 100));

    final counts = <int>[];
    final subscription = repository.watchUnreadCount().listen(counts.add);

    await settle();
    expect(counts, hasLength(1));
    final initial = counts.first;

    await repository.markRead('notif_001');
    await settle();
    expect(counts.last, initial - 1);

    await repository.addNotification(
      AppNotification(
        id: 'notif_new',
        category: NotificationCategory.status,
        title: 'title',
        body: 'body',
        timestamp: DateTime(2026, 9, 29, 12),
        read: false,
      ),
    );
    await settle();
    expect(counts.last, initial - 1 + 1);

    await subscription.cancel();
  });

  test('markAllRead clears every unread row and pushes a zero count', () async {
    final counts = <int>[];
    final subscription = repository.watchUnreadCount().listen(counts.add);
    await Future<void>.delayed(const Duration(milliseconds: 100));
    expect(counts.first, 2);

    final result = await repository.markAllRead();
    await Future<void>.delayed(const Duration(milliseconds: 100));

    expect(result, isA<Ok<void>>());
    expect(counts.last, 0);
    final notifications =
        ((await repository.getNotifications()) as Ok<List<AppNotification>>)
            .value;
    expect(notifications.every((n) => n.read), isTrue);

    await subscription.cancel();
  });

  test(
    'with notifications off: no new rows, badge is 0, existing readable',
    () async {
      await repository.getNotifications(); // seed
      final counts = <int>[];
      final subscription = repository.watchUnreadCount().listen(counts.add);
      await Future<void>.delayed(const Duration(milliseconds: 100));
      expect(counts.last, 2);

      await localStore.setNotificationsEnabled(false);
      await Future<void>.delayed(const Duration(milliseconds: 100));
      expect(counts.last, 0);

      await repository.addNotification(
        AppNotification(
          id: 'notif_blocked',
          category: NotificationCategory.status,
          title: 'title',
          body: 'body',
          timestamp: DateTime(2026, 9, 29, 12),
          read: false,
        ),
      );
      final notifications =
          ((await repository.getNotifications()) as Ok<List<AppNotification>>)
              .value;
      expect(notifications.any((n) => n.id == 'notif_blocked'), isFalse);
      expect(notifications, hasLength(9));

      await localStore.setNotificationsEnabled(true);
      await Future<void>.delayed(const Duration(milliseconds: 100));
      expect(counts.last, 2);

      await subscription.cancel();
    },
  );

  test('seed timestamps are rebased to the clock at seeding time', () async {
    clock.setNow(
      NotificationRepositoryImpl.seedAnchor.add(const Duration(days: 40)),
    );

    final notifications =
        ((await repository.getNotifications()) as Ok<List<AppNotification>>)
            .value;

    expect(
      notifications.first.timestamp,
      DateTime(2026, 9, 29, 10, 26).add(const Duration(days: 40)),
    );
  });
}
