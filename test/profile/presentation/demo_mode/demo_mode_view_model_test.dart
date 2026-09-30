import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tumbas_servis/booking/data/di/booking_data_module.dart';
import 'package:tumbas_servis/core/data/di/core_data_module.dart';
import 'package:tumbas_servis/core/data/service/demo_content_seeder.dart';
import 'package:tumbas_servis/core/data/service/demo_mode_controller.dart';
import 'package:tumbas_servis/core/data/service/demo_reset_service.dart';
import 'package:tumbas_servis/core/data/service/tracking_simulator.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking_status.dart';
import 'package:tumbas_servis/core/domain/model/booking/unit_status.dart';
import 'package:tumbas_servis/core/domain/model/result.dart';
import 'package:tumbas_servis/home/presentation/di/home_presentation_module.dart';
import 'package:tumbas_servis/profile/presentation/demo_mode/state/demo_mode_state.dart';
import 'package:tumbas_servis/profile/presentation/di/profile_presentation_module.dart';
import 'package:tumbas_servis/tracking/data/di/tracking_data_module.dart';

import '../../../support/fake_booking_repository.dart';
import '../../../support/fake_tracking_repository.dart';
import '../../../support/noop_demo_content_seeder.dart';
import '../../../support/tracking_fixtures.dart';

class _FakeResetService implements DemoResetService {
  _FakeResetService(this.log);

  final List<String> log;
  bool fail = false;

  @override
  Future<void> reset() async {
    log.add('reset');
    if (fail) throw Exception('boom');
  }
}

class _RecordingSeeder extends NoopDemoContentSeeder {
  _RecordingSeeder(this.log);

  final List<String> log;

  @override
  Future<void> seedIfNeeded({SeedProgressCallback? onProgress}) async =>
      log.add('seed');
}

void main() {
  late FakeBookingRepository bookingRepository;
  late FakeTrackingRepository trackingRepository;
  late DemoModeController controller;
  late List<String> log;
  late _FakeResetService resetService;
  late ProviderContainer container;

  final provider = demoModeViewModelProvider;

  setUp(() {
    log = [];
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
    resetService = _FakeResetService(log);
    container = ProviderContainer(
      overrides: [
        bookingRepositoryProvider.overrideWithValue(bookingRepository),
        trackingRepositoryProvider.overrideWithValue(trackingRepository),
        demoModeControllerProvider.overrideWithValue(controller),
        demoResetServiceProvider.overrideWithValue(resetService),
        demoContentSeederProvider.overrideWithValue(_RecordingSeeder(log)),
      ],
    );
    addTearDown(container.dispose);
    addTearDown(controller.dispose);
  });

  Future<DemoModeState> settle() async {
    container.listen(provider, (_, _) {});
    for (var i = 0; i < 50; i++) {
      final state = container.read(provider);
      if (!state.isLoading && !state.isBusy && !state.isResetting) break;
      await Future<void>.delayed(const Duration(milliseconds: 5));
    }
    return container.read(provider);
  }

  test('loads the first berlangsung booking with its units', () async {
    final state = await settle();

    expect(state.hasActiveBooking, isTrue);
    expect(state.bookingId, 'bk1');
    expect(state.units.map((u) => u.unitCode), ['-A', '-B', '-C']);
    expect(state.speed, TrackingSpeed.detik15);
    expect(state.errorArmed, isFalse);
    expect(state.canAdvanceAny, isTrue);
  });

  test(
    'no berlangsung booking -> no-active state, controls are inert',
    () async {
      bookingRepository.bookingsResult = const Result.ok([]);

      final state = await settle();
      final ok = await container.read(provider.notifier).advanceAll();

      expect(state.hasActiveBooking, isFalse);
      expect(state.canAdvanceAny, isFalse);
      expect(ok, isFalse);
      expect(trackingRepository.advanceCalls, isEmpty);
    },
  );

  test('load failure -> error state, retry recovers', () async {
    bookingRepository.bookingsResult = Result.error(Exception('boom'));
    var state = await settle();
    expect(state.hasError, isTrue);

    bookingRepository.bookingsResult = const Result.ok([]);
    await container.read(provider.notifier).retry();
    state = await settle();

    expect(state.hasError, isFalse);
  });

  group('speed', () {
    test('the segmented control drives DemoModeController', () async {
      await settle();

      container.read(provider.notifier).setSpeed(TrackingSpeed.detik5);

      expect(container.read(provider).speed, TrackingSpeed.detik5);
      expect(controller.trackingSpeed, TrackingSpeed.detik5);
    });

    test(
      'changing speed re-schedules TrackingSimulator at the new interval',
      () async {
        final intervals = <Duration>[];
        final timers = <Timer>[];
        final simulator = TrackingSimulator(
          demoModeController: controller,
          timerFactory: (duration, callback) {
            intervals.add(duration);
            final timer = Timer(const Duration(hours: 1), callback);
            timers.add(timer);
            return timer;
          },
        );
        addTearDown(simulator.dispose);
        addTearDown(() {
          for (final timer in timers) {
            timer.cancel();
          }
        });
        await settle();
        simulator.checkIn('bk1', '-A');
        expect(intervals, [const Duration(seconds: 15)]);

        container.read(provider.notifier).setSpeed(TrackingSpeed.detik5);

        expect(intervals.last, const Duration(seconds: 5));
      },
    );
  });

  group('error simulation', () {
    test(
      'arms once, fails the next write, then auto-disarms the toggle',
      () async {
        await settle();

        container.read(provider.notifier).setErrorArmed(true);
        expect(container.read(provider).errorArmed, isTrue);
        expect(controller.isErrorArmed, isTrue);

        expect(controller.consumeArmedError(), isTrue);

        expect(container.read(provider).errorArmed, isFalse);
        expect(controller.consumeArmedError(), isFalse);
      },
    );

    test('switching it off disarms without a write', () async {
      await settle();
      final notifier = container.read(provider.notifier);

      notifier.setErrorArmed(true);
      notifier.setErrorArmed(false);

      expect(container.read(provider).errorArmed, isFalse);
      expect(controller.isErrorArmed, isFalse);
    });

    test('an already-armed error shows on open', () async {
      controller.armNextWriteError();

      final state = await settle();

      expect(state.errorArmed, isTrue);
    });
  });

  group('status controls (same TrackingRepository path as S21)', () {
    test('Majukan / Reset call the repository for that unit', () async {
      await settle();
      final notifier = container.read(provider.notifier);

      expect(await notifier.advanceUnit('-B'), isTrue);
      expect(await notifier.resetUnit('-C'), isTrue);

      expect(trackingRepository.advanceCalls, [
        (bookingId: 'bk1', unitCode: '-B'),
      ]);
      expect(trackingRepository.resetCalls, [
        (bookingId: 'bk1', unitCode: '-C'),
      ]);
    });

    test(
      'a repository failure is reported and the panel stays usable',
      () async {
        await settle();
        trackingRepository.advanceResult = Result.error(Exception('boom'));

        final ok = await container.read(provider.notifier).advanceUnit('-A');

        expect(ok, isFalse);
        expect(container.read(provider).isBusy, isFalse);
      },
    );

    test('live updates from the tracking stream reach the unit rows', () async {
      await settle();

      trackingRepository.emit(
        'bk1',
        trackedUnit('-C', UnitStatus.dikerjakan, nickname: 'PCX 160'),
      );

      final unitC = container
          .read(provider)
          .units
          .singleWhere((u) => u.unitCode == '-C');
      expect(unitC.status, UnitStatus.dikerjakan);
    });

    test('Majukan semua skips units already at Selesai', () async {
      bookingRepository.bookingsResult = Result.ok([
        trackedBooking('bk1', [
          trackedUnit('-A', UnitStatus.selesai),
          trackedUnit('-B', UnitStatus.dikerjakan),
          trackedUnit('-C', UnitStatus.diperiksa),
        ], status: BookingStatus.berlangsung),
      ]);
      await settle();

      await container.read(provider.notifier).advanceAll();

      expect(trackingRepository.advanceCalls.map((c) => c.unitCode), [
        '-B',
        '-C',
      ]);
    });

    test('Reset semua resets every unit', () async {
      await settle();

      await container.read(provider.notifier).resetAll();

      expect(trackingRepository.resetCalls.map((c) => c.unitCode), [
        '-A',
        '-B',
        '-C',
      ]);
    });

    test('a second action while one is running is ignored', () async {
      await settle();
      final notifier = container.read(provider.notifier);

      final first = notifier.advanceUnit('-A');
      final second = await notifier.advanceUnit('-B');
      await first;

      expect(second, isFalse);
      expect(trackingRepository.advanceCalls, hasLength(1));
    });
  });

  group('Reset semua data', () {
    test('resets, re-seeds, then reloads the panel', () async {
      await settle();

      final ok = await container.read(provider.notifier).resetAllData();

      expect(ok, isTrue);
      expect(log, ['reset', 'seed']);
      final state = container.read(provider);
      expect(state.isResetting, isFalse);
      expect(state.hasActiveBooking, isTrue);
    });

    test('does not touch the demo settings (speed stays)', () async {
      await settle();
      container.read(provider.notifier).setSpeed(TrackingSpeed.detik5);

      await container.read(provider.notifier).resetAllData();

      expect(controller.trackingSpeed, TrackingSpeed.detik5);
      expect(container.read(provider).speed, TrackingSpeed.detik5);
    });

    test('a failed reset reports false and does not seed', () async {
      await settle();
      resetService.fail = true;

      final ok = await container.read(provider.notifier).resetAllData();

      expect(ok, isFalse);
      expect(log, ['reset']);
      expect(container.read(provider).isResetting, isFalse);
    });
  });
}
