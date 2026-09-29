import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tumbas_servis/app/navigation/routes.dart';
import 'package:tumbas_servis/booking/data/di/booking_data_module.dart';
import 'package:tumbas_servis/booking/presentation/pilih_motor/pilih_motor_args.dart';
import 'package:tumbas_servis/core/data/di/core_data_module.dart';
import 'package:tumbas_servis/core/data/service/demo_content_seeder.dart';
import 'package:tumbas_servis/core/domain/model/booking/unit_status.dart';
import 'package:tumbas_servis/core/domain/model/result.dart';
import 'package:tumbas_servis/notification/data/di/notification_data_module.dart';
import 'package:tumbas_servis/notification/presentation/di/notification_presentation_module.dart';
import 'package:tumbas_servis/notification/presentation/notifikasi/state/notifikasi_state.dart';
import 'package:tumbas_servis/notification/presentation/utils/notification_grouping.dart';

import '../../../support/fake_booking_repository.dart';
import '../../../support/fake_clock.dart';
import '../../../support/fake_notification_repository.dart';
import '../../../support/notification_fixtures.dart';
import '../../../support/tracking_fixtures.dart';

void main() {
  late FakeNotificationRepository repository;
  late FakeBookingRepository bookingRepository;
  late ProviderContainer container;

  setUp(() {
    repository = FakeNotificationRepository(
      notifications: designNotifications(),
    );
    bookingRepository = FakeBookingRepository()
      ..bookingsResult = Result.ok([
        trackedBooking('bk_real_1', [
          trackedUnit('-C', UnitStatus.diperiksa),
        ]).copyWith(code: DemoContentSeeder.canonicalBookingCode),
      ]);
    container = ProviderContainer(
      overrides: [
        notificationRepositoryProvider.overrideWithValue(repository),
        bookingRepositoryProvider.overrideWithValue(bookingRepository),
        clockProvider.overrideWithValue(FakeClock(notificationsNow)),
      ],
    );
    addTearDown(container.dispose);
  });

  final provider = notifikasiViewModelProvider;

  Future<NotifikasiState> settle() async {
    container.listen(provider, (_, _) {});
    for (var i = 0; i < 50; i++) {
      final state = container.read(provider);
      if (!state.isLoading && !state.isMarkingAll) break;
      await Future<void>.delayed(const Duration(milliseconds: 5));
    }
    return container.read(provider);
  }

  test(
    'loads grouped notifications; unread count matches the S05 bell',
    () async {
      final state = await settle();
      final bell = await repository.watchUnreadCount().first;

      expect(state.isReady, isTrue);
      expect(state.groups.map((g) => g.kind), NotificationGroupKind.values);
      expect(state.unreadCount, 2);
      expect(state.unreadCount, bell);
    },
  );

  test('no notifications -> empty state', () async {
    repository.notifications.clear();

    final state = await settle();

    expect(state.isEmpty, isTrue);
    expect(state.groups, isEmpty);
  });

  test('load failure -> error state, retry recovers', () async {
    repository.failGet = true;
    var state = await settle();
    expect(state.hasError, isTrue);

    repository.failGet = false;
    await container.read(provider.notifier).retry();
    state = await settle();

    expect(state.hasError, isFalse);
    expect(state.isReady, isTrue);
  });

  group('open', () {
    test(
      'an unread tap marks it read first, then resolves its target',
      () async {
        await settle();
        final unread = repository.notifications.first;

        final target = await container.read(provider.notifier).open(unread);

        expect(repository.markReadCalls, ['n1']);
        expect(container.read(provider).unreadCount, 1);
        expect(target!.location, Routes.bookingUnitDetail('bk_real_1', '-C'));
      },
    );

    test('a read tap does not write again', () async {
      await settle();

      await container.read(provider.notifier).open(repository.notifications[2]);

      expect(repository.markReadCalls, isEmpty);
    });

    test('each category resolves to its route + params', () async {
      await settle();
      final open = container.read(provider.notifier).open;
      final byId = {for (final n in designNotifications()) n.id: n};

      // Real ids are not in the seed alias, so use direct paths.
      final status = await open(byId['n8']!); // invoice ready -> S23
      final reminder = await open(byId['n6']!);
      final promo = await open(byId['n7']!);

      expect(status!.location, Routes.invoice('bk_seed_001'));
      expect(reminder!.location, Routes.bookingVehicles);
      expect((reminder.extra! as PilihMotorArgs).motorIds, ['motor_004']);
      expect(promo!.location, Routes.bookingVehicles);
      expect((promo.extra! as PilihMotorArgs).voucherId, 'voucher_hemat25');
    });

    test('a notification without a deep link has no target', () async {
      repository.notifications
        ..clear()
        ..add(notificationFixture('plain'));
      await settle();

      final target = await container
          .read(provider.notifier)
          .open(repository.notifications.single);

      expect(target, isNull);
    });
  });

  group('markAllRead', () {
    test('marks everything read and disables further marking', () async {
      await settle();

      final ok = await container.read(provider.notifier).markAllRead();

      expect(ok, isTrue);
      expect(repository.markAllReadCalls, 1);
      expect(container.read(provider).unreadCount, 0);
      expect(await container.read(provider.notifier).markAllRead(), isFalse);
      expect(repository.markAllReadCalls, 1);
    });

    test('a failure keeps the unread rows', () async {
      repository.failMarkAll = true;
      await settle();

      final ok = await container.read(provider.notifier).markAllRead();

      expect(ok, isFalse);
      expect(container.read(provider).unreadCount, 2);
      expect(container.read(provider).isMarkingAll, isFalse);
    });
  });

  test('a notification that arrives while open is picked up', () async {
    await settle();

    await repository.addNotification(
      notificationFixture('n_new', at: notificationsNow, title: 'Baru'),
    );
    await Future<void>.delayed(const Duration(milliseconds: 20));

    final state = container.read(provider);
    expect(state.notifications.any((n) => n.id == 'n_new'), isTrue);
    expect(state.unreadCount, 3);
  });
}
