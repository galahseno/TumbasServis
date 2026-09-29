import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:tumbas_servis/app/app_theme.dart';
import 'package:tumbas_servis/app/navigation/routes.dart';
import 'package:tumbas_servis/booking/data/di/booking_data_module.dart';
import 'package:tumbas_servis/catalog/data/di/catalog_data_module.dart';
import 'package:tumbas_servis/core/data/di/core_data_module.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking.dart';
import 'package:tumbas_servis/core/domain/model/booking/unit_status.dart';
import 'package:tumbas_servis/core/domain/model/result.dart';
import 'package:tumbas_servis/core/domain/model/workshop/time_slot.dart';
import 'package:tumbas_servis/invoice/data/di/invoice_data_module.dart';
import 'package:tumbas_servis/review/data/di/review_data_module.dart';
import 'package:tumbas_servis/tracking/data/di/tracking_data_module.dart';
import 'package:tumbas_servis/tracking/presentation/detail_booking/detail_booking_page.dart';
import 'package:tumbas_servis/tracking/presentation/lacak_unit/lacak_unit_page.dart';
import 'package:tumbas_servis/tracking/presentation/riwayat/riwayat_page.dart';
import 'package:tumbas_servis/workshop/data/di/workshop_data_module.dart';

import '../../support/fake_booking_repository.dart';
import '../../support/fake_catalog_repository.dart';
import '../../support/fake_clock.dart';
import '../../support/fake_invoice_repository.dart';
import '../../support/fake_review_repository.dart';
import '../../support/fake_tracking_repository.dart';
import '../../support/fake_workshop_repository.dart';
import '../../support/tracking_fixtures.dart';

Future<void> _settle(WidgetTester tester) async {
  for (var i = 0; i < 20; i++) {
    await tester.pump(const Duration(milliseconds: 50));
  }
}

void _expectNoException(WidgetTester tester) {
  final exception = tester.takeException();
  if (exception == null) return;
  fail(
    exception is FlutterError ? exception.toStringDeep() : exception.toString(),
  );
}

final _today = DateTime(2026, 9, 29);

List<TimeSlot> _slots() => [
  for (var hour = 8; hour <= 16; hour++)
    TimeSlot(date: _today, hour: hour, capacity: 5, booked: hour == 9 ? 3 : 1),
];

Booking _terjadwal() => trackedBooking('t1', [
  trackedUnit('-A', UnitStatus.terjadwal, motorId: 'm1', nickname: 'Vario 125'),
  trackedUnit(
    '-B',
    UnitStatus.terjadwal,
    motorId: 'm2',
    nickname: 'Beat 110',
    partIds: const ['part_oli'],
  ),
]);

Booking _berlangsung() => trackedBooking('b1', [
  trackedUnit(
    '-A',
    UnitStatus.dikerjakan,
    motorId: 'm1',
    nickname: 'Vario 125',
    mechanicId: 'mech_002',
  ),
  trackedUnit(
    '-B',
    UnitStatus.dikerjakan,
    motorId: 'm2',
    nickname: 'Beat 110',
    mechanicId: 'mech_001',
  ),
  trackedUnit('-C', UnitStatus.diperiksa, motorId: 'm3', nickname: 'PCX 160'),
]);

Booking _selesai() => trackedBooking('s1', [
  trackedUnit('-A', UnitStatus.selesai, motorId: 'm1', nickname: 'Vario 125'),
  trackedUnit('-B', UnitStatus.selesai, motorId: 'm2', nickname: 'Beat 110'),
]);

Booking _dibatalkan() => trackedBooking('d1', [
  trackedUnit('-A', UnitStatus.dibatalkan, motorId: 'm2', nickname: 'Beat 110'),
]);

void main() {
  late FakeBookingRepository bookingRepository;
  late FakeTrackingRepository trackingRepository;
  late FakeInvoiceRepository invoiceRepository;
  late FakeWorkshopRepository workshopRepository;

  setUpAll(() async {
    await initializeDateFormatting('id_ID', null);
  });

  setUp(() {
    bookingRepository = FakeBookingRepository()
      ..bookingsResult = Result.ok([
        _terjadwal(),
        _berlangsung(),
        _selesai(),
        _dibatalkan(),
      ]);
    trackingRepository = FakeTrackingRepository();
    invoiceRepository = FakeInvoiceRepository();
    workshopRepository = FakeWorkshopRepository()
      ..workshopsResult = const Result.ok([workshopFixture])
      ..workshopResult = const Result.ok(workshopFixture)
      ..mechanicsResult = const Result.ok(mechanicFixtures)
      ..availableSlotsResult = Result.ok(_slots());
  });

  /// Boots [initial] inside a router that also knows the neighbouring routes,
  /// so back/forward navigation is real.
  Future<GoRouter> pump(
    WidgetTester tester, {
    required String initial,
    Size size = const Size(412, 915),
    double textScale = 1,
    Booking? booking,
  }) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    tester.platformDispatcher.textScaleFactorTestValue = textScale;
    addTearDown(tester.view.reset);
    addTearDown(tester.platformDispatcher.clearAllTestValues);

    if (booking != null) {
      bookingRepository.getBookingResult = Result.ok(booking);
    }

    final router = GoRouter(
      initialLocation: initial,
      routes: [
        GoRoute(
          path: Routes.bookings,
          builder: (_, state) =>
              RiwayatPage(motorFilterId: state.extra as String?),
        ),
        GoRoute(
          path: Routes.bookingDetailTemplate,
          builder: (_, state) =>
              DetailBookingPage(bookingId: state.pathParameters['id']!),
        ),
        GoRoute(
          path: Routes.bookingUnitDetailTemplate,
          builder: (_, state) => LacakUnitPage(
            bookingId: state.pathParameters['id']!,
            unitCode: state.pathParameters['unitCode']!,
          ),
        ),
        GoRoute(
          path: Routes.invoiceTemplate,
          builder: (_, _) => const Scaffold(body: Text('invoice page')),
        ),
        GoRoute(
          path: Routes.workshopDetailTemplate,
          builder: (_, _) => const Scaffold(body: Text('workshop page')),
        ),
        GoRoute(
          path: Routes.bookingVehicles,
          builder: (_, state) => Scaffold(body: Text('rebook ${state.extra}')),
        ),
      ],
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          bookingRepositoryProvider.overrideWithValue(bookingRepository),
          trackingRepositoryProvider.overrideWithValue(trackingRepository),
          invoiceRepositoryProvider.overrideWithValue(invoiceRepository),
          reviewRepositoryProvider.overrideWithValue(FakeReviewRepository()),
          workshopRepositoryProvider.overrideWithValue(workshopRepository),
          catalogRepositoryProvider.overrideWithValue(
            FakeCatalogRepository()
              ..serviceTypesResult = const Result.ok(serviceFixtures)
              ..partsResult = const Result.ok(partFixtures),
          ),
          clockProvider.overrideWithValue(FakeClock(DateTime(2026, 9, 29, 6))),
        ],
        child: MaterialApp.router(theme: AppTheme.light, routerConfig: router),
      ),
    );
    await _settle(tester);
    return router;
  }

  group('S19 Riwayat', () {
    testWidgets('shows tab counts and opens on Berlangsung', (tester) async {
      await pump(tester, initial: Routes.bookings);

      expect(find.text('Mendatang · 1'), findsOneWidget);
      expect(find.text('Berlangsung · 1'), findsOneWidget);
      expect(find.text('Selesai · 1'), findsOneWidget);
      expect(find.text('Dibatalkan · 1'), findsOneWidget);
      expect(find.text('TS-b1'), findsOneWidget);
      expect(find.text('TS-t1'), findsNothing);
    });

    testWidgets('switching tabs swaps the list', (tester) async {
      await pump(tester, initial: Routes.bookings);

      await tester.tap(find.text('Mendatang · 1'));
      await _settle(tester);

      expect(find.text('TS-t1'), findsOneWidget);
      expect(find.text('TS-b1'), findsNothing);
    });

    testWidgets('an empty tab shows its empty state; Dibatalkan has no CTA', (
      tester,
    ) async {
      bookingRepository.bookingsResult = Result.ok([_berlangsung()]);
      await pump(tester, initial: Routes.bookings);

      await tester.ensureVisible(find.text('Dibatalkan · 0'));
      await tester.tap(find.text('Dibatalkan · 0'));
      await _settle(tester);
      expect(find.text('Tidak ada booking dibatalkan'), findsOneWidget);
      expect(find.text('Booking servis'), findsNothing);

      await tester.tap(find.text('Selesai · 0'));
      await _settle(tester);
      expect(find.text('Belum ada servis selesai'), findsOneWidget);
      expect(find.text('Booking servis'), findsOneWidget);
    });

    testWidgets('tapping a card opens S20', (tester) async {
      await pump(tester, initial: Routes.bookings);
      bookingRepository.getBookingResult = Result.ok(_berlangsung());

      await tester.tap(find.text('TS-b1'));
      await _settle(tester);

      expect(find.text('Detail booking'), findsOneWidget);
    });

    testWidgets('the motor filter chip is dismissible and recomputes counts', (
      tester,
    ) async {
      final router = await pump(tester, initial: '/');
      router.go(Routes.bookings);
      // go() without extra keeps it unfiltered; push with extra filters.
      await _settle(tester);
      router.push(Routes.bookings, extra: 'm2');
      await _settle(tester);

      expect(find.text('Riwayat servis'), findsOneWidget);
      expect(find.text('Beat 110'), findsWidgets);

      await tester.tap(find.byIcon(Icons.close_rounded));
      await _settle(tester);
      expect(find.byIcon(Icons.close_rounded), findsNothing);
    });

    testWidgets('load failure shows a retry state', (tester) async {
      bookingRepository.bookingsResult = Result.error(Exception('x'));
      await pump(tester, initial: Routes.bookings);

      expect(
        find.text('Gagal memuat riwayat booking. Coba lagi.'),
        findsOneWidget,
      );
    });
  });

  group('S20 Detail Booking', () {
    testWidgets('Terjadwal: both actions enabled, no reason lines', (
      tester,
    ) async {
      await pump(
        tester,
        initial: Routes.bookingDetail('t1'),
        booking: _terjadwal(),
      );

      expect(find.text('TS-t1'), findsOneWidget);
      expect(find.text('Bengkel Jaya Motor'), findsOneWidget);
      expect(find.text('Unit -A · Servis Berkala'), findsOneWidget);
      expect(find.text('Unit -B · Servis Berkala + Oli'), findsOneWidget);
      expect(find.text('Ubah jadwal'), findsOneWidget);
      expect(find.text('Batalkan'), findsOneWidget);
      expect(find.textContaining('Sudah check-in'), findsNothing);
    });

    testWidgets('Berlangsung: actions stay visible with their reasons', (
      tester,
    ) async {
      await pump(
        tester,
        initial: Routes.bookingDetail('b1'),
        booking: _berlangsung(),
      );

      expect(find.text('Ubah jadwal'), findsOneWidget);
      expect(find.text('Batalkan'), findsOneWidget);
      expect(
        find.text('Sudah check-in — jadwal tidak bisa diubah'),
        findsOneWidget,
      );
      expect(
        find.text('Sudah check-in — booking tidak bisa dibatalkan'),
        findsOneWidget,
      );
      // Fleet legend.
      expect(find.text('A · Dikerjakan'), findsOneWidget);
      expect(find.text('C · Diperiksa'), findsOneWidget);
    });

    testWidgets('Selesai unpaid: review is gated with its reason', (
      tester,
    ) async {
      await pump(
        tester,
        initial: Routes.bookingDetail('s1'),
        booking: _selesai(),
      );

      expect(find.text('Lihat invoice'), findsOneWidget);
      expect(find.text('Beri ulasan'), findsOneWidget);
      expect(find.text('Tandai lunas di invoice dulu'), findsOneWidget);
      expect(find.text('Booking lagi'), findsOneWidget);
      expect(find.text('Ubah jadwal'), findsNothing);
    });

    testWidgets('Selesai paid: no gate reason', (tester) async {
      invoiceRepository.paid = true;
      await pump(
        tester,
        initial: Routes.bookingDetail('s1'),
        booking: _selesai(),
      );

      expect(find.text('Tandai lunas di invoice dulu'), findsNothing);
    });

    testWidgets('Dibatalkan: shows the cancel date and Booking lagi', (
      tester,
    ) async {
      await pump(
        tester,
        initial: Routes.bookingDetail('d1'),
        booking: _dibatalkan(),
      );

      expect(find.text('Dibatalkan 29 Sep 2026'), findsOneWidget);
      expect(find.text('Booking lagi'), findsOneWidget);
      expect(find.text('Batalkan'), findsNothing);
    });

    testWidgets('"Booking lagi" rebooks with every motor of the booking', (
      tester,
    ) async {
      await pump(
        tester,
        initial: Routes.bookingDetail('s1'),
        booking: _selesai(),
      );

      await tester.tap(find.text('Booking lagi'));
      await _settle(tester);

      expect(find.text('rebook [m1, m2]'), findsOneWidget);
    });

    testWidgets('a unit row opens S21', (tester) async {
      await pump(
        tester,
        initial: Routes.bookingDetail('b1'),
        booking: _berlangsung(),
      );

      await tester.tap(find.text('PCX 160'));
      await _settle(tester);

      expect(find.text('Lacak unit'), findsOneWidget);
    });

    testWidgets('back with an empty stack (S18 used go) lands on Riwayat', (
      tester,
    ) async {
      final router = await pump(
        tester,
        initial: Routes.bookingDetail('b1'),
        booking: _berlangsung(),
      );
      expect(router.canPop(), isFalse);

      await tester.tap(find.byIcon(Icons.arrow_back_rounded).first);
      await _settle(tester);

      expect(
        router.routerDelegate.currentConfiguration.uri.path,
        Routes.bookings,
      );
    });

    testWidgets('Batalkan: pick one unit + reason → repository gets both', (
      tester,
    ) async {
      await pump(
        tester,
        initial: Routes.bookingDetail('t1'),
        booking: _terjadwal(),
      );

      await tester.tap(find.text('Batalkan'));
      await _settle(tester);
      expect(find.text('Batalkan booking?'), findsOneWidget);
      expect(find.text('Seluruh booking · 2 motor'), findsOneWidget);
      expect(
        find.textContaining('Pembatalan tidak bisa diurungkan.'),
        findsOneWidget,
      );

      await tester.tap(find.text('Hanya Beat 110 · Unit -B'));
      await tester.tap(find.text('Jadwal bentrok'));
      await tester.pump();
      await tester.tap(find.text('Ya, batalkan'));
      await _settle(tester);

      expect(bookingRepository.cancelCalls.single, (
        id: 't1',
        unitCode: '-B',
        reason: 'Jadwal bentrok',
      ));
      expect(find.text('Unit -B dibatalkan'), findsOneWidget);
    });

    testWidgets('Batalkan: "Kembali" closes without cancelling', (
      tester,
    ) async {
      await pump(
        tester,
        initial: Routes.bookingDetail('t1'),
        booking: _terjadwal(),
      );

      await tester.tap(find.text('Batalkan'));
      await _settle(tester);
      await tester.tap(find.text('Kembali'));
      await _settle(tester);

      expect(find.text('Batalkan booking?'), findsNothing);
      expect(bookingRepository.cancelCalls, isEmpty);
    });

    testWidgets('Ubah jadwal: the sheet marks the current slot and a '
        'no-change save just closes it', (tester) async {
      await pump(
        tester,
        initial: Routes.bookingDetail('t1'),
        booking: _terjadwal(),
      );

      await tester.tap(find.text('Ubah jadwal'));
      await _settle(tester);

      expect(find.text('Jadwal sekarang'), findsOneWidget);
      expect(find.text('Simpan jadwal'), findsOneWidget);
      expect(
        find.textContaining('Jam 09.00 adalah jadwal sekarang'),
        findsOneWidget,
      );

      await tester.tap(find.text('Simpan jadwal'));
      await _settle(tester);

      expect(find.text('Simpan jadwal'), findsNothing);
      expect(bookingRepository.rescheduleCalls, isEmpty);
    });

    testWidgets('Ubah jadwal: a failed save keeps the sheet open with the '
        'inline error', (tester) async {
      await pump(
        tester,
        initial: Routes.bookingDetail('t1'),
        booking: _terjadwal(),
      );

      await tester.tap(find.text('Ubah jadwal'));
      await _settle(tester);
      await tester.tap(find.text('14.00'));
      await tester.pump();
      await tester.tap(find.text('Simpan jadwal'));
      await _settle(tester);

      expect(find.text('Gagal menyimpan jadwal'), findsOneWidget);
      expect(find.text('Coba lagi'), findsOneWidget);
      expect(find.text('Simpan jadwal'), findsOneWidget);
    });
  });

  group('S21 Lacak Unit', () {
    testWidgets('live: header, ETA, timeline, mechanic and Mode Demo', (
      tester,
    ) async {
      await pump(
        tester,
        initial: Routes.bookingUnitDetail('b1', '-B'),
        booking: _berlangsung(),
      );

      expect(find.text('Beat 110'), findsOneWidget);
      expect(find.textContaining('Unit -B'), findsWidgets);
      expect(find.text('Estimasi selesai'), findsOneWidget);
      expect(find.textContaining('±10.15'), findsOneWidget);
      expect(find.text('Check-in'), findsOneWidget);
      expect(find.text('Sedang dikerjakan · mulai 09.15'), findsOneWidget);
      expect(find.text('Mas Rudi'), findsOneWidget);
      expect(find.text('MODE DEMO'), findsOneWidget);
    });

    testWidgets('unassigned mechanic shows the placeholder copy', (
      tester,
    ) async {
      await pump(
        tester,
        initial: Routes.bookingUnitDetail('b1', '-C'),
        booking: _berlangsung(),
      );

      expect(find.text('Montir belum ditentukan'), findsOneWidget);
    });

    testWidgets('Majukan status / Reset call the tracking repository', (
      tester,
    ) async {
      await pump(
        tester,
        initial: Routes.bookingUnitDetail('b1', '-B'),
        booking: _berlangsung(),
      );

      await tester.ensureVisible(find.text('Majukan status'));
      await tester.tap(find.text('Majukan status'));
      await _settle(tester);
      await tester.ensureVisible(find.text('Reset'));
      await tester.tap(find.text('Reset'));
      await _settle(tester);

      expect(trackingRepository.advanceCalls.single, (
        bookingId: 'b1',
        unitCode: '-B',
      ));
      expect(trackingRepository.resetCalls.single, (
        bookingId: 'b1',
        unitCode: '-B',
      ));
    });

    testWidgets('a live stream update moves the timeline to the next step', (
      tester,
    ) async {
      await pump(
        tester,
        initial: Routes.bookingUnitDetail('b1', '-B'),
        booking: _berlangsung(),
      );
      expect(find.text('Sedang dikerjakan · mulai 09.15'), findsOneWidget);

      trackingRepository.emit(
        'b1',
        trackedUnit(
          '-B',
          UnitStatus.qc,
          motorId: 'm2',
          nickname: 'Beat 110',
          mechanicId: 'mech_001',
        ),
      );
      await _settle(tester);

      expect(find.text('Sedang QC · mulai 09.20'), findsOneWidget);
      expect(find.text('Sedang dikerjakan · mulai 09.15'), findsNothing);
    });

    testWidgets('completed: shows the finish card and disables Majukan', (
      tester,
    ) async {
      await pump(
        tester,
        initial: Routes.bookingUnitDetail('s1', '-A'),
        booking: _selesai(),
      );

      expect(find.text('Selesai'), findsWidgets);
      expect(find.text('Estimasi selesai'), findsNothing);
      await tester.ensureVisible(find.text('Majukan status'));
      await tester.tap(find.text('Majukan status'), warnIfMissed: false);
      await _settle(tester);
      expect(trackingRepository.advanceCalls, isEmpty);
    });

    testWidgets('cancelled: cancel card with reason, no Mode Demo, rebook', (
      tester,
    ) async {
      await pump(
        tester,
        initial: Routes.bookingUnitDetail('d1', '-A'),
        booking: _dibatalkan(),
      );

      expect(find.text('Booking dibatalkan'), findsOneWidget);
      expect(find.textContaining('Jadwal bentrok'), findsOneWidget);
      expect(find.text('MODE DEMO'), findsNothing);
      expect(find.text('Booking lagi'), findsOneWidget);
    });

    testWidgets('back with an empty stack returns to S20', (tester) async {
      final router = await pump(
        tester,
        initial: Routes.bookingUnitDetail('b1', '-B'),
        booking: _berlangsung(),
      );

      await tester.tap(find.byIcon(Icons.arrow_back_rounded).first);
      await _settle(tester);

      expect(
        router.routerDelegate.currentConfiguration.uri.path,
        Routes.bookingDetail('b1'),
      );
    });
  });

  group('phone layout matrix (no overflow)', () {
    const sizes = [Size(320, 568), Size(360, 640), Size(412, 915)];
    const scales = [1.0, 1.3];

    for (final size in sizes) {
      for (final scale in scales) {
        final label = '${size.width.toInt()}x${size.height.toInt()} ×$scale';

        testWidgets('S19 $label', (tester) async {
          await pump(
            tester,
            initial: Routes.bookings,
            size: size,
            textScale: scale,
          );
          _expectNoException(tester);
        });

        testWidgets('S20 Berlangsung $label', (tester) async {
          await pump(
            tester,
            initial: Routes.bookingDetail('b1'),
            booking: _berlangsung(),
            size: size,
            textScale: scale,
          );
          _expectNoException(tester);
        });

        testWidgets('S20 Selesai $label', (tester) async {
          await pump(
            tester,
            initial: Routes.bookingDetail('s1'),
            booking: _selesai(),
            size: size,
            textScale: scale,
          );
          _expectNoException(tester);
        });

        testWidgets('S21 live $label', (tester) async {
          await pump(
            tester,
            initial: Routes.bookingUnitDetail('b1', '-B'),
            booking: _berlangsung(),
            size: size,
            textScale: scale,
          );
          _expectNoException(tester);
        });

        testWidgets('S22 sheet + dialog $label', (tester) async {
          await pump(
            tester,
            initial: Routes.bookingDetail('t1'),
            booking: _terjadwal(),
            size: size,
            textScale: scale,
          );
          await tester.tap(find.text('Ubah jadwal'));
          await _settle(tester);
          _expectNoException(tester);

          await tester.tapAt(const Offset(10, 10)); // scrim
          await _settle(tester);
          await tester.tap(find.text('Batalkan'));
          await _settle(tester);
          _expectNoException(tester);
        });
      }
    }
  });
}
