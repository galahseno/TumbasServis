import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:tumbas_servis/app/app_theme.dart';
import 'package:tumbas_servis/app/navigation/routes.dart';
import 'package:tumbas_servis/booking/data/di/booking_data_module.dart';
import 'package:tumbas_servis/core/data/di/core_data_module.dart';
import 'package:tumbas_servis/core/data/service/demo_mode_controller.dart';
import 'package:tumbas_servis/core/data/service/demo_reset_service.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking_status.dart';
import 'package:tumbas_servis/core/domain/model/booking/unit_status.dart';
import 'package:tumbas_servis/core/domain/model/result.dart';
import 'package:tumbas_servis/core/presentation/components/ts_button.dart';
import 'package:tumbas_servis/core/presentation/components/ts_switch.dart';
import 'package:tumbas_servis/home/presentation/di/home_presentation_module.dart';
import 'package:tumbas_servis/profile/presentation/demo_mode/demo_mode_page.dart';
import 'package:tumbas_servis/tracking/data/di/tracking_data_module.dart';

import '../../../support/fake_booking_repository.dart';
import '../../../support/fake_tracking_repository.dart';
import '../../../support/noop_demo_content_seeder.dart';
import '../../../support/tracking_fixtures.dart';

class _CountingResetService implements DemoResetService {
  int resets = 0;

  @override
  Future<void> reset() async => resets++;
}

Future<void> _settle(WidgetTester tester) async {
  for (var i = 0; i < 10; i++) {
    await tester.pump(const Duration(milliseconds: 50));
  }
}

TsButton _button(WidgetTester tester, String label) => tester.widget<TsButton>(
  find.ancestor(of: find.text(label), matching: find.byType(TsButton)).first,
);

void main() {
  late FakeBookingRepository bookingRepository;
  late FakeTrackingRepository trackingRepository;
  late DemoModeController controller;
  late _CountingResetService resetService;

  setUpAll(() async {
    await initializeDateFormatting('id_ID', null);
  });

  setUp(() {
    bookingRepository = FakeBookingRepository()
      ..bookingsResult = Result.ok([
        trackedBooking('bk1', [
          trackedUnit('-A', UnitStatus.dikerjakan, nickname: 'Vario 125'),
          trackedUnit('-B', UnitStatus.dikerjakan, nickname: 'Beat 110'),
          trackedUnit('-C', UnitStatus.diperiksa, nickname: 'PCX 160'),
        ], status: BookingStatus.berlangsung),
      ]);
    trackingRepository = FakeTrackingRepository();
    controller = DemoModeController();
    resetService = _CountingResetService();
    addTearDown(controller.dispose);
  });

  Future<GoRouter> pump(
    WidgetTester tester, {
    Size size = const Size(412, 915),
    double textScale = 1,
  }) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    tester.platformDispatcher.textScaleFactorTestValue = textScale;
    addTearDown(tester.view.reset);
    addTearDown(tester.platformDispatcher.clearAllTestValues);

    final router = GoRouter(
      initialLocation: Routes.profileDemoMode,
      routes: [
        GoRoute(
          path: Routes.profileDemoMode,
          builder: (_, _) => const DemoModePage(),
        ),
        GoRoute(
          path: Routes.home,
          builder: (_, _) => const Scaffold(body: Text('home page')),
        ),
        GoRoute(
          path: Routes.profile,
          builder: (_, _) => const Scaffold(body: Text('profil page')),
        ),
      ],
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          bookingRepositoryProvider.overrideWithValue(bookingRepository),
          trackingRepositoryProvider.overrideWithValue(trackingRepository),
          demoModeControllerProvider.overrideWithValue(controller),
          demoResetServiceProvider.overrideWithValue(resetService),
          demoContentSeederProvider.overrideWithValue(NoopDemoContentSeeder()),
        ],
        child: MaterialApp.router(theme: AppTheme.light, routerConfig: router),
      ),
    );
    await _settle(tester);
    return router;
  }

  testWidgets('default: caption once, four panels, unit rows and footer', (
    tester,
  ) async {
    await pump(tester);

    expect(
      find.text('Kontrol status khusus demo — bukan bagian produk.'),
      findsOneWidget,
    );
    expect(find.text('MODE DEMO'), findsNWidgets(4));
    expect(find.text('Kecepatan'), findsOneWidget);
    expect(find.text('Mati'), findsOneWidget);
    expect(find.text('15 dtk'), findsOneWidget);
    expect(find.text('5 dtk'), findsOneWidget);
    expect(find.text('Status booking TS-bk1'), findsOneWidget);
    expect(find.text('-A Vario 125'), findsOneWidget);
    expect(find.text('-B Beat 110'), findsOneWidget);
    expect(find.text('-C PCX 160'), findsOneWidget);
    expect(find.text('Dikerjakan'), findsNWidgets(2));
    expect(find.text('Diperiksa'), findsOneWidget);
    expect(find.text('Majukan'), findsNWidgets(3));
    expect(find.text('Majukan semua'), findsOneWidget);
    expect(find.text('Simulasikan galat jaringan'), findsOneWidget);
    expect(find.text('Reset semua data'), findsOneWidget);
  });

  testWidgets('speed: choosing 5 dtk updates the controller', (tester) async {
    await pump(tester);

    await tester.tap(find.text('5 dtk'));
    await _settle(tester);

    expect(controller.trackingSpeed, TrackingSpeed.detik5);
  });

  testWidgets('per-unit Majukan calls the repository for that unit', (
    tester,
  ) async {
    await pump(tester);

    await tester.tap(find.text('Majukan').first);
    await _settle(tester);

    expect(trackingRepository.advanceCalls, [
      (bookingId: 'bk1', unitCode: '-A'),
    ]);
  });

  testWidgets('Majukan semua / Reset semua loop every unit', (tester) async {
    await pump(tester);

    await tester.ensureVisible(find.text('Majukan semua'));
    await tester.pump();
    await tester.tap(find.text('Majukan semua'));
    await _settle(tester);
    await tester.ensureVisible(find.text('Reset semua'));
    await tester.pump();
    await tester.tap(find.text('Reset semua'));
    await _settle(tester);

    expect(trackingRepository.advanceCalls, hasLength(3));
    expect(trackingRepository.resetCalls, hasLength(3));
  });

  testWidgets('a failed advance shows an error snackbar', (tester) async {
    trackingRepository.advanceResult = Result.error(Exception('boom'));
    await pump(tester);

    await tester.tap(find.text('Majukan').first);
    await _settle(tester);

    expect(find.text('Gagal memajukan status. Coba lagi.'), findsOneWidget);
  });

  testWidgets('unit Selesai: its Majukan is disabled', (tester) async {
    bookingRepository.bookingsResult = Result.ok([
      trackedBooking('bk1', [
        trackedUnit('-A', UnitStatus.selesai, nickname: 'Vario 125'),
        trackedUnit('-B', UnitStatus.dikerjakan, nickname: 'Beat 110'),
      ], status: BookingStatus.berlangsung),
    ]);
    await pump(tester);

    final majukan = find.byWidgetPredicate(
      (w) => w is TsButton && w.label == 'Majukan',
    );
    final buttons = tester.widgetList<TsButton>(majukan).toList();
    expect(buttons[0].onPressed, isNull);
    expect(buttons[1].onPressed, isNotNull);
  });

  testWidgets('no active booking: reason line, controls disabled', (
    tester,
  ) async {
    bookingRepository.bookingsResult = const Result.ok([]);
    await pump(tester);

    expect(
      find.text(
        'Belum ada booking berlangsung. Buat booking dulu untuk memakai '
        'kontrol status.',
      ),
      findsOneWidget,
    );
    expect(find.text('Majukan'), findsNothing);
    expect(_button(tester, 'Majukan semua').onPressed, isNull);
    expect(_button(tester, 'Reset semua').onPressed, isNull);
    // Data reset still works with nothing running.
    expect(_button(tester, 'Reset semua data').onPressed, isNotNull);
  });

  testWidgets('error armed: banner shows, then the switch disarms itself', (
    tester,
  ) async {
    await pump(tester);
    expect(find.text('Aksi berikutnya akan gagal'), findsNothing);

    await tester.ensureVisible(find.byType(TsSwitch));
    await tester.pump();
    await tester.tap(find.byType(TsSwitch));
    await _settle(tester);
    expect(find.text('Aksi berikutnya akan gagal'), findsOneWidget);
    expect(tester.widget<TsSwitch>(find.byType(TsSwitch)).value, isTrue);

    controller.consumeArmedError();
    await _settle(tester);

    expect(find.text('Aksi berikutnya akan gagal'), findsNothing);
    expect(tester.widget<TsSwitch>(find.byType(TsSwitch)).value, isFalse);
  });

  testWidgets('reset dialog: Batal does nothing', (tester) async {
    await pump(tester);

    await tester.ensureVisible(find.text('Reset semua data'));
    await tester.pump();
    await tester.tap(find.text('Reset semua data'));
    await _settle(tester);
    expect(find.text('Reset semua data?'), findsOneWidget);

    await tester.tap(find.text('Batal'));
    await _settle(tester);

    expect(resetService.resets, 0);
    expect(find.text('home page'), findsNothing);
  });

  testWidgets('reset confirmed: data restored, snackbar, back to Home', (
    tester,
  ) async {
    await pump(tester);

    await tester.ensureVisible(find.text('Reset semua data'));
    await tester.pump();
    await tester.tap(find.text('Reset semua data'));
    await _settle(tester);
    await tester.tap(find.text('Ya, reset data'));
    await _settle(tester);

    expect(resetService.resets, 1);
    expect(find.text('home page'), findsOneWidget);
    expect(find.text('Data demo dikembalikan'), findsOneWidget);
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
      expect(find.text('Kecepatan'), findsOneWidget);
    });
  }
}
