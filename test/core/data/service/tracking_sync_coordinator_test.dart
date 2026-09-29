import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive_ce.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tumbas_servis/core/data/service/demo_mode_controller.dart';
import 'package:tumbas_servis/core/data/service/local_store.dart';
import 'package:tumbas_servis/core/data/service/tracking_simulator.dart';
import 'package:tumbas_servis/core/data/service/tracking_status_writer.dart';
import 'package:tumbas_servis/core/data/service/tracking_sync_coordinator.dart';
import 'package:tumbas_servis/core/domain/model/booking/unit_status.dart';

import '../../../support/fake_clock.dart';
import '../../../support/manual_timer_factory.dart';
import '../../../support/tracking_store_fixtures.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory tempDir;
  late LocalStore store;
  late ManualTimerFactory timers;
  late TrackingSimulator simulator;
  late TrackingSyncCoordinator coordinator;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    tempDir = Directory.systemTemp.createTempSync('tracking_sync_test');
    store = LocalStore(
      preferences: await SharedPreferences.getInstance(),
      resolveStorageDirectory: () async => tempDir.path,
    );
    timers = ManualTimerFactory();
    simulator = TrackingSimulator(
      demoModeController: DemoModeController()
        ..setTrackingSpeed(TrackingSpeed.detik5),
      timerFactory: timers.call,
    );
    coordinator = TrackingSyncCoordinator(
      trackingSimulator: simulator,
      localStore: store,
      clock: FakeClock(DateTime(2026, 9, 29, 10)),
    );
    await store.put(
      'bookings',
      'bk',
      rawBooking('bk', [
        rawUnit('-A', 'dikerjakan'),
        rawUnit('-B', 'terjadwal'),
        rawUnit('-C', 'selesai'),
      ], status: 'berlangsung'),
    );
  });

  tearDown(() async {
    coordinator.dispose();
    simulator.dispose();
    await Hive.close();
    tempDir.deleteSync(recursive: true);
  });

  Future<String> storedStatus(String code) async {
    await TrackingStatusWriter.pendingWrites;
    final row = await store.get('bookings', 'bk');
    final units = (row!['units'] as List<dynamic>).cast<Map<String, dynamic>>();
    return units.firstWhere((u) => u['unit_code'] == code)['status'] as String;
  }

  test('start hydrates mid-flow units only, without emitting', () async {
    final emitted = <TrackingTransition>[];
    simulator.transitions.listen(emitted.add);

    await coordinator.start();

    expect(simulator.currentStatus('bk', '-A'), UnitStatus.dikerjakan);
    expect(simulator.isTracking('bk', '-A'), isTrue);
    expect(simulator.isTracking('bk', '-B'), isFalse);
    expect(simulator.isTracking('bk', '-C'), isFalse);
    expect(emitted, isEmpty);
  });

  test('a timer tick after hydration is persisted to the store', () async {
    await coordinator.start();

    timers.fire(); // dikerjakan -> qc
    expect(await storedStatus('-A'), 'qc');
  });

  test('explicit simulator advance/reset are persisted too', () async {
    await coordinator.start();

    simulator.advance('bk', '-B'); // terjadwal -> checkIn
    expect(await storedStatus('-B'), 'checkIn');

    simulator.reset('bk', '-B');
    expect(await storedStatus('-B'), 'terjadwal');
  });

  test('does not persist after dispose', () async {
    await coordinator.start();
    coordinator.dispose();

    simulator.advance('bk', '-B');
    expect(await storedStatus('-B'), 'terjadwal');
  });
}
