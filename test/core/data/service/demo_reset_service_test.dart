import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive_ce.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tumbas_servis/auth/data/repository/session_repository_impl.dart';
import 'package:tumbas_servis/booking/data/repository/booking_repository_impl.dart';
import 'package:tumbas_servis/catalog/data/repository/catalog_repository_impl.dart';
import 'package:tumbas_servis/core/data/service/demo_content_seeder.dart';
import 'package:tumbas_servis/core/data/service/demo_reset_service.dart';
import 'package:tumbas_servis/core/data/service/demo_mode_controller.dart';
import 'package:tumbas_servis/core/data/service/local_store.dart';
import 'package:tumbas_servis/core/data/service/mock_json_loader.dart';
import 'package:tumbas_servis/core/data/service/tracking_simulator.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking_draft.dart';
import 'package:tumbas_servis/core/domain/model/booking/unit_status.dart';
import 'package:tumbas_servis/core/domain/model/result.dart';
import 'package:tumbas_servis/core/domain/repository/settings/app_theme_mode.dart';
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
  late LocalStore store;
  late TrackingSimulator simulator;
  late DemoModeController demoModeController;
  late DemoResetService resetService;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    tempDir = Directory.systemTemp.createTempSync('demo_seeder_test');
    final localStore = store = LocalStore(
      preferences: await SharedPreferences.getInstance(),
      resolveStorageDirectory: () async => tempDir.path,
    );
    final clock = FakeClock(DateTime(2026, 9, 29, 9, 0));
    final latency = FakeLatencySimulator();
    demoModeController = DemoModeController();
    simulator = TrackingSimulator(demoModeController: demoModeController);

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
    );
    resetService = DemoResetService(
      localStore: localStore,
      trackingSimulator: simulator,
      demoModeController: demoModeController,
    );
  });

  tearDown(() async {
    await Hive.close();
    tempDir.deleteSync(recursive: true);
  });

  test('reset clears every demo box but keeps session, theme and demo '
      'settings', () async {
    await store.setThemeMode(AppThemeMode.dark);
    await store.setDemoModeEnabled(true);
    await store.setSessionFlag(true);
    for (final box in DemoResetService.resetBoxes) {
      await store.put(box, 'row', {'id': 'row'});
    }
    await store.put('session', 'user', {'id': 'user_001'});

    await resetService.reset();

    for (final box in DemoResetService.resetBoxes) {
      expect(await store.getAll(box), isEmpty, reason: box);
    }
    expect(await store.get('session', 'user'), isNotNull);
    expect(store.getSessionFlag(), isTrue);
    expect(store.getThemeMode(), AppThemeMode.dark);
    expect(store.getDemoModeEnabled(), isTrue);
  });

  test('reset disarms a pending error and drops tracked units', () async {
    demoModeController.armNextWriteError();
    simulator.hydrate('bk1', '-A', UnitStatus.dikerjakan);

    await resetService.reset();

    expect(demoModeController.isErrorArmed, isFalse);
    expect(simulator.isTracking('bk1', '-A'), isFalse);
  });

  test('reset + reseed restores the canonical booking TS-260929-0417 and '
      'the demo draft', () async {
    await seeder.seedIfNeeded();
    final before =
        ((await bookingRepository.getBookings()) as Ok<List<Booking>>).value;
    final canonical = before.singleWhere(
      (b) => b.code == DemoContentSeeder.canonicalBookingCode,
    );
    await trackingRepository.advanceUnitStatus(
      bookingId: canonical.id,
      unitCode: '-C',
    );
    await bookingRepository.deleteDraft();

    await resetService.reset();
    await seeder.seedIfNeeded();

    final after =
        ((await bookingRepository.getBookings()) as Ok<List<Booking>>).value;
    expect(after, hasLength(before.length));
    final restored = after.singleWhere(
      (b) => b.code == DemoContentSeeder.canonicalBookingCode,
    );
    final statusByUnit = {for (final u in restored.units) u.unitCode: u.status};
    expect(statusByUnit['-C'], UnitStatus.diperiksa);
    final draft =
        ((await bookingRepository.getCurrentDraft()) as Ok<BookingDraft?>)
            .value;
    expect(draft?.selectedMotorIds, [DemoContentSeeder.draftMotorId]);
  });

  test('every Hive box the repositories write, except session, is in '
      'resetBoxes (drift guard)', () async {
    await seeder.seedIfNeeded();
    await Hive.close();

    final used =
        tempDir
            .listSync()
            .whereType<File>()
            .map((f) => f.uri.pathSegments.last)
            .where((name) => name.endsWith('.hive'))
            .map((name) => name.substring(0, name.length - '.hive'.length))
            .toSet()
          ..remove('session');

    expect(DemoResetService.resetBoxes, containsAll(used));
  });
}
