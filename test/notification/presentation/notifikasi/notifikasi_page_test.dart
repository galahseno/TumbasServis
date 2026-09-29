import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:tumbas_servis/app/app_theme.dart';
import 'package:tumbas_servis/app/navigation/routes.dart';
import 'package:tumbas_servis/booking/data/di/booking_data_module.dart';
import 'package:tumbas_servis/core/data/di/core_data_module.dart';
import 'package:tumbas_servis/core/data/service/demo_content_seeder.dart';
import 'package:tumbas_servis/core/domain/model/booking/unit_status.dart';
import 'package:tumbas_servis/core/domain/model/result.dart';
import 'package:tumbas_servis/core/presentation/components/ts_button.dart';
import 'package:tumbas_servis/notification/data/di/notification_data_module.dart';
import 'package:tumbas_servis/notification/presentation/notifikasi/notifikasi_page.dart';

import '../../../support/fake_booking_repository.dart';
import '../../../support/fake_clock.dart';
import '../../../support/fake_notification_repository.dart';
import '../../../support/notification_fixtures.dart';
import '../../../support/tracking_fixtures.dart';

TsButton _markAllButton(WidgetTester tester) => tester.widget<TsButton>(
  find.ancestor(
    of: find.text('Tandai semua dibaca'),
    matching: find.byType(TsButton),
  ),
);

Future<void> _settle(WidgetTester tester) async {
  for (var i = 0; i < 20; i++) {
    await tester.pump(const Duration(milliseconds: 50));
  }
}

void main() {
  late FakeNotificationRepository repository;
  late FakeBookingRepository bookingRepository;

  setUpAll(() async {
    await initializeDateFormatting('id_ID', null);
  });

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
  });

  Future<GoRouter> pump(
    WidgetTester tester, {
    Size size = const Size(412, 915),
    double textScale = 1,
    bool settle = true,
  }) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    tester.platformDispatcher.textScaleFactorTestValue = textScale;
    addTearDown(tester.view.reset);
    addTearDown(tester.platformDispatcher.clearAllTestValues);

    final router = GoRouter(
      initialLocation: Routes.notifications,
      routes: [
        GoRoute(
          path: Routes.notifications,
          builder: (_, _) => const NotifikasiPage(),
        ),
        GoRoute(
          path: Routes.bookingUnitDetailTemplate,
          builder: (_, state) => Scaffold(
            body: Text(
              'unit ${state.pathParameters['id']} '
              '${state.pathParameters['unitCode']}',
            ),
          ),
        ),
        GoRoute(
          path: Routes.invoiceTemplate,
          builder: (_, state) => Scaffold(
            body: Text('invoice ${state.pathParameters['bookingId']}'),
          ),
        ),
        GoRoute(
          path: Routes.bookingVehicles,
          builder: (_, _) => const Scaffold(body: Text('pilih motor')),
        ),
      ],
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          notificationRepositoryProvider.overrideWithValue(repository),
          bookingRepositoryProvider.overrideWithValue(bookingRepository),
          clockProvider.overrideWithValue(FakeClock(notificationsNow)),
        ],
        child: MaterialApp.router(theme: AppTheme.light, routerConfig: router),
      ),
    );
    if (settle) await _settle(tester);
    return router;
  }

  testWidgets('populated: three groups with the designed titles and stamps', (
    tester,
  ) async {
    await pump(tester);

    expect(find.text('Hari ini'), findsOneWidget);
    expect(find.text('Minggu ini'), findsOneWidget);
    expect(find.text('Lebih lama'), findsOneWidget);
    expect(find.text('PCX 160 sedang diperiksa'), findsOneWidget);
    expect(find.text('Status · 10.26'), findsOneWidget);
    expect(find.text('Pengingat · Sen 28 Sep'), findsOneWidget);
    expect(find.text('Promo · Sab 26 Sep'), findsOneWidget);
    expect(find.text('Tandai semua dibaca'), findsOneWidget);
  });

  testWidgets('unread rows announce "Belum dibaca" (not colour alone)', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    await pump(tester);

    expect(
      find.bySemanticsLabel(RegExp(r'^Belum dibaca\. ')),
      findsNWidgets(2),
    );
    handle.dispose();
  });

  testWidgets('tap: marks read, then opens the unit page (alias resolved)', (
    tester,
  ) async {
    await pump(tester);

    await tester.tap(find.text('PCX 160 sedang diperiksa'));
    await _settle(tester);

    expect(repository.markReadCalls, ['n1']);
    expect(find.text('unit bk_real_1 -C'), findsOneWidget);
  });

  testWidgets('tap: invoice ready opens S23, promo opens S10', (tester) async {
    final router = await pump(tester);

    await tester.ensureVisible(find.text('Servis selesai'));
    await tester.pump();
    await tester.tap(find.text('Servis selesai'));
    await _settle(tester);
    expect(find.text('invoice bk_seed_001'), findsOneWidget);

    router.pop();
    await _settle(tester);
    await tester.ensureVisible(find.text('Potongan Rp25.000 servis'));
    await tester.pump();
    await tester.tap(find.text('Potongan Rp25.000 servis'));
    await _settle(tester);
    expect(find.text('pilih motor'), findsOneWidget);
  });

  testWidgets('"Tandai semua dibaca" clears unread, then disables itself', (
    tester,
  ) async {
    await pump(tester);

    await tester.tap(find.text('Tandai semua dibaca'));
    await _settle(tester);

    expect(repository.markAllReadCalls, 1);
    expect(_markAllButton(tester).onPressed, isNull);
  });

  testWidgets('all read: action is disabled from the start', (tester) async {
    for (var i = 0; i < repository.notifications.length; i++) {
      repository.notifications[i] = repository.notifications[i].copyWith(
        read: true,
      );
    }
    await pump(tester);

    expect(_markAllButton(tester).onPressed, isNull);
  });

  testWidgets('empty: "Belum ada notifikasi"', (tester) async {
    repository.notifications.clear();
    await pump(tester);

    expect(find.text('Belum ada notifikasi'), findsOneWidget);
    expect(find.text('Tandai semua dibaca'), findsNothing);
  });

  testWidgets('loading: skeleton, no list yet', (tester) async {
    repository.delay = const Duration(seconds: 5);
    await pump(tester, settle: false);
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.byType(NotifikasiPage), findsOneWidget);
    expect(find.text('Hari ini'), findsNothing);
    expect(find.text('Notifikasi'), findsOneWidget);

    await tester.pump(const Duration(seconds: 6));
  });

  testWidgets('error: retry recovers', (tester) async {
    repository.failGet = true;
    await pump(tester);
    expect(find.text('Gagal memuat notifikasi. Coba lagi.'), findsOneWidget);

    repository.failGet = false;
    await tester.tap(find.text('Coba lagi'));
    await _settle(tester);

    expect(find.text('Hari ini'), findsOneWidget);
  });

  for (final (size, scale) in [
    (const Size(320, 568), 1.0),
    (const Size(360, 640), 1.3),
    (const Size(412, 915), 1.3),
  ]) {
    testWidgets('layout: no overflow at ${size.width}x${size.height} ×$scale', (
      tester,
    ) async {
      await pump(tester, size: size, textScale: scale);

      expect(tester.takeException(), isNull);
      expect(find.text('Lebih lama'), findsOneWidget);
    });
  }
}
