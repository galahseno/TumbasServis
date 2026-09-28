import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive_ce.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tumbas_servis/core/data/service/demo_mode_controller.dart';
import 'package:tumbas_servis/core/data/service/local_store.dart';
import 'package:tumbas_servis/core/data/service/mock_json_loader.dart';
import 'package:tumbas_servis/core/data/service/status_notification_coordinator.dart';
import 'package:tumbas_servis/core/data/service/tracking_simulator.dart';
import 'package:tumbas_servis/core/domain/model/notification/app_notification.dart';
import 'package:tumbas_servis/core/domain/model/result.dart';
import 'package:tumbas_servis/notification/data/repository/notification_repository_impl.dart';

import '../../../support/fake_clock.dart';
import '../../../support/fake_latency_simulator.dart';
import '../../../support/manual_timer_factory.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Map<String, dynamic> bookingJson({
    required String id,
    required String unitCode,
    required String nickname,
  }) => {
    'id': id,
    'code': 'TS-260929-0001',
    'user_id': 'user_001',
    'workshop_id': 'ws_001',
    'units': [
      {
        'unit_code': unitCode,
        'motor_id': 'motor_001',
        'motor_snapshot': {
          'id': 'motor_001',
          'owner_id': 'user_001',
          'nickname': nickname,
          'plate_number': 'AB 1234 XY',
          'year': 2022,
          'model_id': 'model_vario125',
        },
        'service_ids': ['svc_berkala'],
        'part_ids': <String>[],
        'status': 'terjadwal',
        'status_history': [
          {
            'status': 'terjadwal',
            'timestamp': DateTime(2026, 9, 29, 9).toIso8601String(),
          },
        ],
        'subtotal': 85000,
        'duration_min': 30,
      },
    ],
    'schedule_mode': 'shared',
    'shared_slot': {
      'date': DateTime(2026, 9, 29).toIso8601String(),
      'hour': 9,
      'capacity': 5,
      'booked': 1,
    },
    'status': 'terjadwal',
    'subtotal': 85000,
    'discount': 0,
    'total': 85000,
    'created_at': DateTime(2026, 9, 29, 8).toIso8601String(),
    'completed_at': null,
  };

  late Directory tempDir;
  late LocalStore localStore;
  late NotificationRepositoryImpl notificationRepository;
  late TrackingSimulator trackingSimulator;
  late ManualTimerFactory pollTimer;
  late StatusNotificationCoordinator coordinator;

  Future<void> settle() =>
      Future<void>.delayed(const Duration(milliseconds: 100));

  Future<List<AppNotification>> statusNotifications() async {
    final result = await notificationRepository.getNotifications();
    final all = (result as Ok<List<AppNotification>>).value;
    return all.where((n) => n.id.startsWith('notif_status_')).toList();
  }

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    tempDir = Directory.systemTemp.createTempSync('status_coordinator_test');
    localStore = LocalStore(
      preferences: await SharedPreferences.getInstance(),
      resolveStorageDirectory: () async => tempDir.path,
    );
    notificationRepository = NotificationRepositoryImpl(
      localStore: localStore,
      mockJsonLoader: MockJsonLoader(),
      latencySimulator: FakeLatencySimulator(),
    );
    trackingSimulator = TrackingSimulator(
      demoModeController: DemoModeController()
        ..setTrackingSpeed(TrackingSpeed.mati),
    );
    pollTimer = ManualTimerFactory();
    coordinator = StatusNotificationCoordinator(
      trackingSimulator: trackingSimulator,
      localStore: localStore,
      notificationRepository: notificationRepository,
      clock: FakeClock(DateTime(2026, 9, 29, 10)),
      timerFactory: pollTimer.call,
    );
  });

  tearDown(() async {
    coordinator.dispose();
    trackingSimulator.dispose();
    await Hive.close();
    tempDir.deleteSync(recursive: true);
  });

  test('writes one notification per unit transition, with the right '
      'deepLink', () async {
    await localStore.put(
      'bookings',
      'bk1',
      bookingJson(id: 'bk1', unitCode: '-A', nickname: 'Vario 125'),
    );
    coordinator.start();
    await settle();

    trackingSimulator.checkIn('bk1', '-A');
    await settle();
    trackingSimulator.advance('bk1', '-A'); // diperiksa
    await settle();
    trackingSimulator.advance('bk1', '-A'); // dikerjakan
    await settle();
    trackingSimulator.advance('bk1', '-A'); // qc
    await settle();
    trackingSimulator.advance('bk1', '-A'); // selesai
    await settle();

    final result = await statusNotifications();
    expect(result, hasLength(5));
    expect(result.every((n) => n.deepLink == '/tracking/bk1/-A'), isTrue);
  });

  test('repeated discovery polls with no activity do not duplicate '
      'subscriptions/notifications', () async {
    await localStore.put(
      'bookings',
      'bk1',
      bookingJson(id: 'bk1', unitCode: '-A', nickname: 'Vario 125'),
    );
    coordinator.start();
    await settle();

    for (var i = 0; i < 5; i++) {
      pollTimer.fire();
      await settle();
    }

    trackingSimulator.checkIn('bk1', '-A');
    await settle();

    final result = await statusNotifications();
    expect(result, hasLength(1));
  });

  test('stops notifying once a unit reaches selesai, even after a later '
      'reset + re-advance', () async {
    await localStore.put(
      'bookings',
      'bk1',
      bookingJson(id: 'bk1', unitCode: '-A', nickname: 'Vario 125'),
    );
    coordinator.start();
    await settle();

    trackingSimulator.checkIn('bk1', '-A');
    trackingSimulator.advance('bk1', '-A');
    trackingSimulator.advance('bk1', '-A');
    trackingSimulator.advance('bk1', '-A');
    trackingSimulator.advance('bk1', '-A'); // selesai
    await settle();
    expect(await statusNotifications(), hasLength(5));

    trackingSimulator.reset('bk1', '-A');
    trackingSimulator.checkIn('bk1', '-A');
    trackingSimulator.advance('bk1', '-A');
    await settle();
    pollTimer.fire();
    await settle();

    expect(await statusNotifications(), hasLength(5));
  });

  test('a booking added mid-session is picked up by the next poll', () async {
    coordinator.start();
    await settle();

    await localStore.put(
      'bookings',
      'bk_late',
      bookingJson(id: 'bk_late', unitCode: '-A', nickname: 'Beat 110'),
    );
    pollTimer.fire();
    await settle();

    trackingSimulator.checkIn('bk_late', '-A');
    await settle();

    final result = await statusNotifications();
    expect(result, hasLength(1));
    expect(result.first.deepLink, '/tracking/bk_late/-A');
  });

  test('dispose stops all further notifications', () async {
    await localStore.put(
      'bookings',
      'bk1',
      bookingJson(id: 'bk1', unitCode: '-A', nickname: 'Vario 125'),
    );
    coordinator.start();
    await settle();
    coordinator.dispose();

    trackingSimulator.checkIn('bk1', '-A');
    trackingSimulator.advance('bk1', '-A');
    await settle();

    expect(await statusNotifications(), isEmpty);
  });
}
