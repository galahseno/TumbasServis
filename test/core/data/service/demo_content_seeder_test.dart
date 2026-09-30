import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive_ce.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tumbas_servis/auth/data/repository/session_repository_impl.dart';
import 'package:tumbas_servis/booking/data/repository/booking_repository_impl.dart';
import 'package:tumbas_servis/catalog/data/repository/catalog_repository_impl.dart';
import 'package:tumbas_servis/core/data/service/demo_content_seeder.dart';
import 'package:tumbas_servis/core/data/service/demo_mode_controller.dart';
import 'package:tumbas_servis/core/data/service/local_store.dart';
import 'package:tumbas_servis/core/data/service/mock_json_loader.dart';
import 'package:tumbas_servis/core/data/service/tracking_simulator.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking_draft.dart';
import 'package:tumbas_servis/core/domain/model/booking/unit_status.dart';
import 'package:tumbas_servis/core/domain/model/result.dart';
import 'package:tumbas_servis/garage/data/repository/garage_repository_impl.dart';
import 'package:tumbas_servis/tracking/data/repository/tracking_repository_impl.dart';

import '../../../support/fake_clock.dart';
import '../../../support/fake_latency_simulator.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory tempDir;
  late BookingRepositoryImpl bookingRepository;
  late TrackingRepositoryImpl trackingRepository;
  late DemoContentSeeder seeder;
  late DemoModeController seedingController;
  late TrackingSimulator simulator;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    tempDir = Directory.systemTemp.createTempSync('demo_seeder_test');
    final localStore = LocalStore(
      preferences: await SharedPreferences.getInstance(),
      resolveStorageDirectory: () async => tempDir.path,
    );
    final clock = FakeClock(DateTime(2026, 9, 29, 9, 0));
    final latency = FakeLatencySimulator();
    seedingController = DemoModeController();
    simulator = TrackingSimulator(demoModeController: DemoModeController());

    final sessionRepository = SessionRepositoryImpl(
      localStore: localStore,
      mockJsonLoader: MockJsonLoader(),
      latencySimulator: latency,
      demoModeController: DemoModeController(),
    );
    await sessionRepository.verifyOtp('123456');

    bookingRepository = BookingRepositoryImpl(
      localStore: localStore,
      mockJsonLoader: MockJsonLoader(),
      latencySimulator: latency,
      clock: clock,
      catalogRepository: CatalogRepositoryImpl(
        mockJsonLoader: MockJsonLoader(),
        latencySimulator: latency,
      ),
      garageRepository: GarageRepositoryImpl(
        localStore: localStore,
        mockJsonLoader: MockJsonLoader(),
        latencySimulator: latency,
        hasActiveBooking: (_) async => false,
      ),
      sessionRepository: sessionRepository,
    );
    trackingRepository = TrackingRepositoryImpl(
      trackingSimulator: simulator,
      localStore: localStore,
      latencySimulator: latency,
      clock: clock,
      bookingRepository: bookingRepository,
    );
    seeder = DemoContentSeeder(
      bookingRepository: bookingRepository,
      trackingRepository: trackingRepository,
      demoModeController: seedingController,
    );
  });

  tearDown(() async {
    await Hive.close();
    tempDir.deleteSync(recursive: true);
  });

  test('creates the canonical active booking (2 dikerjakan + 1 diperiksa) and '
      'the Supra X 125 draft at Langkah 2', () async {
    await seeder.seedIfNeeded();

    final bookings =
        ((await bookingRepository.getBookings()) as Ok<List<Booking>>).value;
    final booking = bookings.singleWhere(
      (b) => b.code == DemoContentSeeder.canonicalBookingCode,
    );
    final statusByUnit = {for (final u in booking.units) u.unitCode: u.status};
    expect(statusByUnit['-A'], UnitStatus.dikerjakan);
    expect(statusByUnit['-B'], UnitStatus.dikerjakan);
    expect(statusByUnit['-C'], UnitStatus.diperiksa);

    final draft =
        ((await bookingRepository.getCurrentDraft()) as Ok<BookingDraft?>)
            .value;
    expect(draft, isNotNull);
    expect(draft!.selectedMotorIds, [DemoContentSeeder.draftMotorId]);
  });

  test('marks the controller as seeding only while it runs', () async {
    final seedingDuringTransitions = <bool>[];
    final subscription = simulator.transitions.listen(
      (_) => seedingDuringTransitions.add(seedingController.isSeeding),
    );

    expect(seedingController.isSeeding, isFalse);
    await seeder.seedIfNeeded();
    await subscription.cancel();

    expect(seedingDuringTransitions, isNotEmpty);
    expect(seedingDuringTransitions.every((seeding) => seeding), isTrue);
    expect(seedingController.isSeeding, isFalse);
  });

  test('reports monotonic progress ending at 100% while seeding', () async {
    final fractions = <double>[];
    await seeder.seedIfNeeded(
      onProgress: (fraction, label) => fractions.add(fraction),
    );

    expect(fractions.first, 0);
    expect(fractions.last, 1);
    expect(fractions.length, greaterThan(5));
    for (var i = 1; i < fractions.length; i++) {
      expect(fractions[i], greaterThanOrEqualTo(fractions[i - 1]));
    }
  });

  test('reports no progress when there is nothing to seed', () async {
    await seeder.seedIfNeeded();
    final fractions = <double>[];

    await seeder.seedIfNeeded(
      onProgress: (fraction, label) => fractions.add(fraction),
    );

    expect(fractions, isEmpty);
  });

  test('is idempotent: a second call does not duplicate the booking', () async {
    await seeder.seedIfNeeded();
    await seeder.seedIfNeeded();

    final bookings =
        ((await bookingRepository.getBookings()) as Ok<List<Booking>>).value;
    expect(
      bookings.where((b) => b.code == DemoContentSeeder.canonicalBookingCode),
      hasLength(1),
    );
  });

  test(
    'the demo draft motor is free: no non-terminal booking unit uses it, '
    'so it can be unselected without reading "Sedang dalam servis"',
    () async {
      await seeder.seedIfNeeded();

      final bookings =
          ((await bookingRepository.getBookings()) as Ok<List<Booking>>).value;
      final inService = bookings
          .expand((b) => b.units)
          .where((u) => !u.status.isTerminal)
          .map((u) => u.motorId);
      expect(inService, isNot(contains(DemoContentSeeder.draftMotorId)));
    },
  );

  test('a cleared draft is not re-seeded on a later launch', () async {
    await seeder.seedIfNeeded();
    await bookingRepository.deleteDraft();

    await seeder.seedIfNeeded();

    final draft =
        ((await bookingRepository.getCurrentDraft()) as Ok<BookingDraft?>)
            .value;
    expect(draft, isNull);
  });
}
