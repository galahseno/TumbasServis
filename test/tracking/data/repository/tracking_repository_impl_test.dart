import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive_ce.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tumbas_servis/auth/data/repository/session_repository_impl.dart';
import 'package:tumbas_servis/booking/data/repository/booking_repository_impl.dart';
import 'package:tumbas_servis/catalog/data/repository/catalog_repository_impl.dart';
import 'package:tumbas_servis/core/data/service/demo_mode_controller.dart';
import 'package:tumbas_servis/core/data/service/local_store.dart';
import 'package:tumbas_servis/core/data/service/mock_json_loader.dart';
import 'package:tumbas_servis/core/data/service/tracking_simulator.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking_status.dart';
import 'package:tumbas_servis/core/domain/model/result.dart';
import 'package:tumbas_servis/garage/data/repository/garage_repository_impl.dart';
import 'package:tumbas_servis/tracking/data/repository/tracking_repository_impl.dart';

import '../../../support/fake_clock.dart';
import '../../../support/fake_latency_simulator.dart';
import '../../../support/manual_timer_factory.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory tempDir;
  late LocalStore localStore;
  late FakeClock clock;
  late DemoModeController demoModeController;
  late TrackingSimulator trackingSimulator;
  late BookingRepositoryImpl bookingRepository;
  late TrackingRepositoryImpl repository;

  const bookingId = 'bk_track_test';
  const unitCode = '-A';

  Map<String, dynamic> singleUnitBookingJson({required String status}) => {
    'id': bookingId,
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
          'nickname': 'Vario 125',
          'plate_number': 'AB 1234 XY',
          'year': 2022,
          'model_id': 'model_vario125',
        },
        'service_ids': ['svc_berkala'],
        'part_ids': <String>[],
        'status': status,
        'status_history': [
          {
            'status': status,
            'timestamp': DateTime(2026, 9, 20, 9).toIso8601String(),
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
    'status': status == 'terjadwal' ? 'terjadwal' : 'berlangsung',
    'subtotal': 85000,
    'discount': 0,
    'total': 85000,
    'created_at': DateTime(2026, 9, 20, 9).toIso8601String(),
    'completed_at': null,
  };

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    tempDir = Directory.systemTemp.createTempSync('tracking_repo_test');
    localStore = LocalStore(
      preferences: await SharedPreferences.getInstance(),
      resolveStorageDirectory: () async => tempDir.path,
    );
    clock = FakeClock(DateTime(2026, 9, 20, 9));
    demoModeController = DemoModeController()
      ..setTrackingSpeed(TrackingSpeed.mati);
    trackingSimulator = TrackingSimulator(
      demoModeController: demoModeController,
    );

    final sessionRepository = SessionRepositoryImpl(
      localStore: localStore,
      mockJsonLoader: MockJsonLoader(),
      latencySimulator: FakeLatencySimulator(),
    );
    await sessionRepository.verifyOtp('123456');

    bookingRepository = BookingRepositoryImpl(
      localStore: localStore,
      mockJsonLoader: MockJsonLoader(),
      latencySimulator: FakeLatencySimulator(),
      clock: clock,
      catalogRepository: CatalogRepositoryImpl(
        mockJsonLoader: MockJsonLoader(),
        latencySimulator: FakeLatencySimulator(),
      ),
      garageRepository: GarageRepositoryImpl(
        localStore: localStore,
        mockJsonLoader: MockJsonLoader(),
        latencySimulator: FakeLatencySimulator(),
        hasActiveBooking: (_) async => false,
      ),
      sessionRepository: sessionRepository,
    );

    repository = TrackingRepositoryImpl(
      trackingSimulator: trackingSimulator,
      localStore: localStore,
      latencySimulator: FakeLatencySimulator(),
      clock: clock,
      bookingRepository: bookingRepository,
    );
  });

  tearDown(() async {
    trackingSimulator.dispose();
    await Hive.close();
    tempDir.deleteSync(recursive: true);
  });

  Future<Booking> booking() async =>
      ((await bookingRepository.getBooking(bookingId)) as Ok<Booking>).value;

  group('advanceUnitStatus', () {
    setUp(() async {
      await localStore.put(
        'bookings',
        bookingId,
        singleUnitBookingJson(status: 'terjadwal'),
      );
    });

    test('walks the unit through the full status machine, persisting '
        'status/history and deriving the booking-level status', () async {
      const expected = ['checkIn', 'diperiksa', 'dikerjakan', 'qc', 'selesai'];

      for (final status in expected) {
        final result = await repository.advanceUnitStatus(
          bookingId: bookingId,
          unitCode: unitCode,
        );
        expect(result, isA<Ok<void>>());

        final current = await booking();
        expect(current.units.single.status.name, status);
      }

      final finalBooking = await booking();
      expect(finalBooking.status, BookingStatus.selesai);
      expect(finalBooking.completedAt, clock.now());
      expect(finalBooking.units.single.statusHistory, hasLength(6));
    });

    test('refuses once the unit already reached a terminal status', () async {
      for (var i = 0; i < 5; i++) {
        await repository.advanceUnitStatus(
          bookingId: bookingId,
          unitCode: unitCode,
        );
      }
      final result = await repository.advanceUnitStatus(
        bookingId: bookingId,
        unitCode: unitCode,
      );
      expect(result, isA<Error<void>>());
    });

    test(
      'refuses a unit persisted as dibatalkan without mutating it',
      () async {
        final raw = await localStore.get('bookings', bookingId);
        final units = (raw!['units'] as List<dynamic>)
            .cast<Map<String, dynamic>>();
        units[0]['status'] = 'dibatalkan';
        await localStore.put('bookings', bookingId, raw);

        final result = await repository.advanceUnitStatus(
          bookingId: bookingId,
          unitCode: unitCode,
        );
        expect(result, isA<Error<void>>());

        final current = await booking();
        expect(current.units.single.status.name, 'dibatalkan');
      },
    );
  });

  group('resetUnitStatus', () {
    test('returns a completed unit to terjadwal and un-completes the '
        'booking', () async {
      await localStore.put(
        'bookings',
        bookingId,
        singleUnitBookingJson(status: 'terjadwal'),
      );
      for (var i = 0; i < 5; i++) {
        await repository.advanceUnitStatus(
          bookingId: bookingId,
          unitCode: unitCode,
        );
      }
      expect((await booking()).status, BookingStatus.selesai);

      final result = await repository.resetUnitStatus(
        bookingId: bookingId,
        unitCode: unitCode,
      );
      expect(result, isA<Ok<void>>());

      final current = await booking();
      expect(current.units.single.status.name, 'terjadwal');
      expect(current.units.single.statusHistory, hasLength(1));
      expect(current.status, BookingStatus.terjadwal);
      expect(current.completedAt, isNull);
    });
  });

  group('watchUnitStatus', () {
    setUp(() async {
      await localStore.put(
        'bookings',
        bookingId,
        singleUnitBookingJson(status: 'terjadwal'),
      );
    });

    test('emits the current persisted unit first, then tracks each '
        'explicit transition', () async {
      final emitted = <String>[];
      final subscription = repository
          .watchUnitStatus(bookingId: bookingId, unitCode: unitCode)
          .listen((unit) => emitted.add(unit.status.name));

      await Future<void>.delayed(const Duration(milliseconds: 50));
      expect(emitted, ['terjadwal']);

      await repository.advanceUnitStatus(
        bookingId: bookingId,
        unitCode: unitCode,
      );
      await Future<void>.delayed(const Duration(milliseconds: 50));
      expect(emitted, ['terjadwal', 'checkIn']);

      await subscription.cancel();
    });

    test('tracks each automatic tick the simulator emits on its own timer, '
        'not just explicit advanceUnitStatus calls', () async {
      final manualTimer = ManualTimerFactory();
      final autoSimulator = TrackingSimulator(
        demoModeController: DemoModeController()
          ..setTrackingSpeed(TrackingSpeed.detik5),
        timerFactory: manualTimer.call,
      );
      final autoRepository = TrackingRepositoryImpl(
        trackingSimulator: autoSimulator,
        localStore: localStore,
        latencySimulator: FakeLatencySimulator(),
        clock: clock,
        bookingRepository: bookingRepository,
      );

      final emitted = <String>[];
      final subscription = autoRepository
          .watchUnitStatus(bookingId: bookingId, unitCode: unitCode)
          .listen((unit) => emitted.add(unit.status.name));
      await Future<void>.delayed(const Duration(milliseconds: 50));
      expect(emitted, ['terjadwal']);

      await autoRepository.advanceUnitStatus(
        bookingId: bookingId,
        unitCode: unitCode,
      );
      await Future<void>.delayed(const Duration(milliseconds: 50));
      expect(emitted.last, 'checkIn');

      for (final expected in ['diperiksa', 'dikerjakan', 'qc', 'selesai']) {
        manualTimer.fire();
        await Future<void>.delayed(const Duration(milliseconds: 50));
        expect(emitted.last, expected);
      }

      await subscription.cancel();
      autoSimulator.dispose();
    });
  });
}
