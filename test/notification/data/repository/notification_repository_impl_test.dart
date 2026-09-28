import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive_ce.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tumbas_servis/core/data/service/local_store.dart';
import 'package:tumbas_servis/core/data/service/mock_json_loader.dart';
import 'package:tumbas_servis/core/domain/model/notification/app_notification.dart';
import 'package:tumbas_servis/core/domain/model/result.dart';
import 'package:tumbas_servis/notification/data/repository/notification_repository_impl.dart';

import '../../../support/fake_latency_simulator.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory tempDir;
  late NotificationRepositoryImpl repository;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    tempDir = Directory.systemTemp.createTempSync('notification_repo_test');
    final localStore = LocalStore(
      preferences: await SharedPreferences.getInstance(),
      resolveStorageDirectory: () async => tempDir.path,
    );
    repository = NotificationRepositoryImpl(
      localStore: localStore,
      mockJsonLoader: MockJsonLoader(),
      latencySimulator: FakeLatencySimulator(),
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
}
