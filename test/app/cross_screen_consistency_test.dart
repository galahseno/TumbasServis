import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive_ce.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tumbas_servis/app/app_theme.dart';
import 'package:tumbas_servis/auth/data/di/auth_data_module.dart';
import 'package:tumbas_servis/booking/data/di/booking_data_module.dart';
import 'package:tumbas_servis/core/data/di/core_data_module.dart';
import 'package:tumbas_servis/core/data/service/demo_content_seeder.dart';
import 'package:tumbas_servis/core/data/service/local_store.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking_status.dart';
import 'package:tumbas_servis/core/domain/model/booking/unit_status.dart';
import 'package:tumbas_servis/core/domain/model/garage/motor.dart';
import 'package:tumbas_servis/core/domain/model/invoice/invoice.dart';
import 'package:tumbas_servis/core/domain/model/notification/app_notification.dart';
import 'package:tumbas_servis/core/domain/model/result.dart';
import 'package:tumbas_servis/core/domain/model/review/review.dart';
import 'package:tumbas_servis/core/presentation/components/unit_status_badge.dart';
import 'package:tumbas_servis/garage/data/di/garage_data_module.dart';
import 'package:tumbas_servis/garage/presentation/motor_detail/components/service_history_row.dart';
import 'package:tumbas_servis/home/presentation/di/home_presentation_module.dart';
import 'package:tumbas_servis/home/presentation/utils/home_booking_display.dart';
import 'package:tumbas_servis/invoice/data/di/invoice_data_module.dart';
import 'package:tumbas_servis/notification/data/di/notification_data_module.dart';
import 'package:tumbas_servis/notification/presentation/di/notification_presentation_module.dart';
import 'package:tumbas_servis/profile/presentation/di/profile_presentation_module.dart';
import 'package:tumbas_servis/review/data/di/review_data_module.dart';
import 'package:tumbas_servis/tracking/data/di/tracking_data_module.dart';
import 'package:tumbas_servis/tracking/presentation/utils/tracking_display.dart';

import '../support/fake_clock.dart';
import '../support/fake_latency_simulator.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await initializeDateFormatting('id_ID', null);
  });

  group('unit status labels agree across S05 / S07-S09 / S19-S21', () {
    const badgeOverrides = {UnitStatus.checkIn: 'Check-in / Antre'};

    for (final status in UnitStatus.values) {
      testWidgets('${status.name}: home, timeline, history row and badge '
          'share one label', (tester) async {
        final handle = tester.ensureSemantics();
        final expected = status.displayLabel;

        expect(status.timelineLabel, expected);

        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.light,
            home: Scaffold(
              body: Column(
                children: [
                  UnitStatusBadge(status: status),
                  ServiceHistoryRow(
                    entry: (
                      bookingId: 'bk',
                      bookingCode: 'TS-260929-0417',
                      unitCode: '-A',
                      code: 'TS-260929-0417-A',
                      status: status,
                      dateTime: DateTime(2026, 9, 29, 9),
                      servicesSummary: 'Servis Berkala',
                      subtotal: 85000,
                    ),
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ),
        );

        expect(
          find.bySemanticsLabel(RegExp('TS-260929-0417-A, $expected, ')),
          findsOneWidget,
        );
        // Badge (S20/S21).
        expect(
          find.text(badgeOverrides[status] ?? expected),
          findsAtLeastNWidgets(1),
        );
        handle.dispose();
      });
    }
  });

  group('real data graph (seeded demo booking)', () {
    late Directory tempDir;
    late ProviderContainer container;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      tempDir = Directory.systemTemp.createTempSync('cross_screen_test');
      container = ProviderContainer(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          localStoreProvider.overrideWithValue(
            LocalStore(
              preferences: prefs,
              resolveStorageDirectory: () async => tempDir.path,
            ),
          ),
          latencySimulatorProvider.overrideWithValue(FakeLatencySimulator()),
          clockProvider.overrideWithValue(
            FakeClock(DateTime(2026, 9, 29, 9, 0)),
          ),
        ],
      );
      await container.read(sessionRepositoryProvider).verifyOtp('123456');
      container.read(statusNotificationCoordinatorProvider);
    });

    tearDown(() async {
      container.dispose();
      await Hive.close();
      tempDir.deleteSync(recursive: true);
    });

    Future<void> until(bool Function() condition, String what) async {
      for (var i = 0; i < 400; i++) {
        if (condition()) return;
        await Future<void>.delayed(const Duration(milliseconds: 10));
      }
      fail('timed out waiting for: $what');
    }

    Future<void> openHomeAndNotifications() async {
      container
        ..listen(homeViewModelProvider, (_, _) {})
        ..listen(notifikasiViewModelProvider, (_, _) {});
      await until(
        () =>
            !container.read(homeViewModelProvider).isLoading &&
            !container.read(notifikasiViewModelProvider).isLoading,
        'home + notifications loaded',
      );
      await until(
        () =>
            container.read(homeViewModelProvider).unreadCount ==
            container.read(notifikasiViewModelProvider).unreadCount,
        'unread badge settled',
      );
    }

    Future<List<Booking>> bookings() async =>
        ((await container.read(bookingRepositoryProvider).getBookings())
                as Ok<List<Booking>>)
            .value;

    Future<int> repoUnread() async {
      final list =
          ((await container
                      .read(notificationRepositoryProvider)
                      .getNotifications())
                  as Ok<List<AppNotification>>)
              .value;
      return list.where((n) => !n.read).length;
    }

    test('unread count: S05 bell == S06 list == repository, through read '
        'and new status events', () async {
      await openHomeAndNotifications();
      final home = container.read(homeViewModelProvider.notifier);
      final notifs = container.read(notifikasiViewModelProvider.notifier);

      int homeCount() => container.read(homeViewModelProvider).unreadCount;
      int listCount() =>
          container.read(notifikasiViewModelProvider).unreadCount;

      final seeded = await repoUnread();
      expect(seeded, greaterThan(0));
      expect(homeCount(), seeded);
      expect(listCount(), seeded);

      final firstUnread = container
          .read(notifikasiViewModelProvider)
          .notifications
          .firstWhere((n) => !n.read);
      await notifs.open(firstUnread);
      await until(() => homeCount() == seeded - 1, 'bell after open');
      expect(listCount(), seeded - 1);
      expect(await repoUnread(), seeded - 1);

      expect(await notifs.markAllRead(), isTrue);
      await until(() => homeCount() == 0, 'bell after mark all');
      expect(listCount(), 0);
      expect(await repoUnread(), 0);

      await Future<void>.delayed(const Duration(milliseconds: 2500));
      final canonical = (await bookings()).singleWhere(
        (b) => b.code == DemoContentSeeder.canonicalBookingCode,
      );
      await container
          .read(trackingRepositoryProvider)
          .advanceUnitStatus(bookingId: canonical.id, unitCode: '-C');
      await until(() => homeCount() > 0, 'bell after status event');
      await until(() => listCount() == homeCount(), 'list catches up');
      expect(await repoUnread(), homeCount());
      expect(home, isNotNull);
    });

    test('booking status: S05 card, S19 tab and S20 header all derive from '
        'the same booking', () async {
      await container.read(demoContentSeederProvider).seedIfNeeded();
      await openHomeAndNotifications();

      final canonical = (await bookings()).singleWhere(
        (b) => b.code == DemoContentSeeder.canonicalBookingCode,
      );
      expect(canonical.status, BookingStatus.berlangsung);
      expect(canonical.status.label, 'Berlangsung');

      final card = container
          .read(homeViewModelProvider)
          .activeBookings
          .singleWhere((d) => d.booking.code == canonical.code);
      final (majorityLabel, caption) = canonical.units
          .map((u) => u.status)
          .toList()
          .majorityStatus;
      expect(card.statusLabel, majorityLabel);
      expect(card.statusCaption, caption);
      expect(card.statusLabel, UnitStatus.dikerjakan.timelineLabel);
      expect(card.booking.status, canonical.status);

      for (final unit in canonical.units) {
        for (var i = 0; i < 6; i++) {
          await container
              .read(trackingRepositoryProvider)
              .advanceUnitStatus(
                bookingId: canonical.id,
                unitCode: unit.unitCode,
              );
        }
      }
      final done = (await bookings()).singleWhere((b) => b.id == canonical.id);
      expect(done.units.every((u) => u.status == UnitStatus.selesai), isTrue);
      expect(done.status, BookingStatus.selesai);
      expect(done.status.label, 'Selesai');
      expect(
        done.units.map((u) => u.status).toList().majorityStatus.$1,
        BookingStatus.selesai.label,
      );
    });

    test('"Reset semua data" round-trip restores every repository to the '
        'seeded demo state', () async {
      await container.read(demoContentSeederProvider).seedIfNeeded();
      await openHomeAndNotifications();

      final garage = container.read(garageRepositoryProvider);
      final baselineMotors =
          ((await garage.getMotors()) as Ok<List<Motor>>).value.length;
      final baselineUnread = await repoUnread();
      final baselineBookings = await bookings();
      final canonical = baselineBookings.singleWhere(
        (b) => b.code == DemoContentSeeder.canonicalBookingCode,
      );
      final baselineStatuses = {
        for (final u in canonical.units) u.unitCode: u.status,
      };

      container.listen(demoModeViewModelProvider, (_, _) {});
      await until(
        () => !container.read(demoModeViewModelProvider).isLoading,
        'demo screen loaded',
      );

      await garage.addMotor(
        const Motor(
          id: 'm_extra',
          ownerId: 'user_001',
          nickname: 'Motor Tambahan',
          plateNumber: 'AB 9999 ZZ',
          modelId: 'model_beat_110',
        ),
      );
      await container.read(notificationRepositoryProvider).markAllRead();
      for (final unit in canonical.units) {
        for (var i = 0; i < 6; i++) {
          await container
              .read(trackingRepositoryProvider)
              .advanceUnitStatus(
                bookingId: canonical.id,
                unitCode: unit.unitCode,
              );
        }
      }
      expect(
        await container.read(invoiceRepositoryProvider).markPaid(canonical.id),
        isA<Ok<void>>(),
      );
      expect(
        await container
            .read(reviewRepositoryProvider)
            .submitReview(
              Review(
                bookingId: canonical.id,
                workshopRating: 5,
                mechanicRatings: const {},
                createdAt: DateTime(2026, 9, 29, 12),
              ),
            ),
        isA<Ok<void>>(),
      );
      container.read(demoModeControllerProvider).armNextWriteError();

      final ok = await container
          .read(demoModeViewModelProvider.notifier)
          .resetAllData();
      expect(ok, isTrue);

      expect(
        ((await garage.getMotors()) as Ok<List<Motor>>).value.length,
        baselineMotors,
      );
      final afterBookings = await bookings();
      expect(afterBookings.length, baselineBookings.length);
      final afterCanonical = afterBookings.singleWhere(
        (b) => b.code == DemoContentSeeder.canonicalBookingCode,
      );
      expect({
        for (final u in afterCanonical.units) u.unitCode: u.status,
      }, baselineStatuses);
      expect(await repoUnread(), baselineUnread);
      expect(
        await container
            .read(invoiceRepositoryProvider)
            .getInvoice(afterCanonical.id),
        isA<Error<Invoice>>(),
      );
      expect(
        ((await container
                    .read(reviewRepositoryProvider)
                    .getReview(afterCanonical.id))
                as Ok)
            .value,
        isNull,
      );
      expect(container.read(demoModeControllerProvider).isErrorArmed, isFalse);
      final draft =
          (await container.read(bookingRepositoryProvider).getCurrentDraft())
              as Ok;
      expect(draft.value, isNotNull);

      await until(
        () =>
            !container.read(homeViewModelProvider).isLoading &&
            !container.read(notifikasiViewModelProvider).isLoading,
        'screens reloaded after reset',
      );
      await until(
        () =>
            container.read(homeViewModelProvider).unreadCount == baselineUnread,
        'bell back to seeded count',
      );
      expect(
        container.read(notifikasiViewModelProvider).unreadCount,
        baselineUnread,
      );
      expect(
        container.read(homeViewModelProvider).motors.length,
        baselineMotors,
      );
      expect(
        container
            .read(homeViewModelProvider)
            .activeBookings
            .single
            .booking
            .code,
        DemoContentSeeder.canonicalBookingCode,
      );
    });
  });
}
