import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tumbas_servis/core/data/service/demo_mode_controller.dart';
import 'package:tumbas_servis/core/data/service/tracking_simulator.dart';
import 'package:tumbas_servis/core/domain/model/booking/unit_status.dart';

void main() {
  test('checkIn advances through the machine at the configured speed and '
      'stops at selesai', () {
    fakeAsync((async) {
      final demoModeController = DemoModeController()
        ..setTrackingSpeed(TrackingSpeed.detik5);
      final simulator = TrackingSimulator(
        demoModeController: demoModeController,
      );
      final statuses = <UnitStatus>[];
      simulator.watch('bk1', '-A').listen(statuses.add);

      simulator.checkIn('bk1', '-A');
      expect(statuses, [UnitStatus.checkIn]);

      // checkIn -> diperiksa -> dikerjakan -> qc -> selesai: 4 more ticks.
      async.elapse(const Duration(seconds: 5 * 4));

      expect(statuses, [
        UnitStatus.checkIn,
        UnitStatus.diperiksa,
        UnitStatus.dikerjakan,
        UnitStatus.qc,
        UnitStatus.selesai,
      ]);

      // No more advancing once terminal, even after more elapsed time.
      async.elapse(const Duration(seconds: 30));
      expect(statuses.last, UnitStatus.selesai);

      simulator.dispose();
    });
  });

  test('manual advance/reset work independent of the timer', () {
    fakeAsync((async) {
      final demoModeController = DemoModeController()
        ..setTrackingSpeed(TrackingSpeed.mati);
      final simulator = TrackingSimulator(
        demoModeController: demoModeController,
      );
      final statuses = <UnitStatus>[];
      simulator.watch('bk1', '-A').listen(statuses.add);

      simulator.checkIn('bk1', '-A');
      async.elapse(const Duration(minutes: 5));
      expect(statuses, [UnitStatus.checkIn], reason: 'mati: no auto-advance');

      simulator.advance('bk1', '-A');
      expect(statuses.last, UnitStatus.diperiksa);

      simulator.reset('bk1', '-A');
      expect(statuses.last, UnitStatus.terjadwal);

      simulator.dispose();
    });
  });

  test('setting speed to mati stops further auto-advance', () {
    fakeAsync((async) {
      final demoModeController = DemoModeController()
        ..setTrackingSpeed(TrackingSpeed.detik15);
      final simulator = TrackingSimulator(
        demoModeController: demoModeController,
      );
      final statuses = <UnitStatus>[];
      simulator.watch('bk1', '-A').listen(statuses.add);

      simulator.checkIn('bk1', '-A');
      async.elapse(const Duration(seconds: 15));
      expect(statuses.last, UnitStatus.diperiksa);

      demoModeController.setTrackingSpeed(TrackingSpeed.mati);
      simulator.advance('bk1', '-A'); // reschedules with the new (off) speed
      final afterManualAdvance = statuses.last;

      async.elapse(const Duration(minutes: 5));
      expect(statuses.last, afterManualAdvance);

      simulator.dispose();
    });
  });

  group('hydrate + transitions', () {
    test('hydrate aligns memory without emitting on watch or transitions', () {
      final simulator = TrackingSimulator(
        demoModeController: DemoModeController()
          ..setTrackingSpeed(TrackingSpeed.mati),
      );
      final watched = <UnitStatus>[];
      final transitions = <TrackingTransition>[];
      simulator.watch('bk1', '-A').listen(watched.add);
      simulator.transitions.listen(transitions.add);

      expect(simulator.isTracking('bk1', '-A'), isFalse);
      simulator.hydrate('bk1', '-A', UnitStatus.dikerjakan);

      expect(simulator.isTracking('bk1', '-A'), isTrue);
      expect(simulator.currentStatus('bk1', '-A'), UnitStatus.dikerjakan);
      expect(watched, isEmpty);
      expect(transitions, isEmpty);

      // A manual advance now continues forward from the hydrated status.
      simulator.advance('bk1', '-A');
      expect(watched, [UnitStatus.qc]);
      simulator.dispose();
    });

    test('hydrate resumes auto-advance for mid-flow units only', () {
      fakeAsync((async) {
        final simulator = TrackingSimulator(
          demoModeController: DemoModeController()
            ..setTrackingSpeed(TrackingSpeed.detik5),
        );
        final transitions = <TrackingTransition>[];
        simulator.transitions.listen(transitions.add);

        simulator.hydrate('bk1', '-A', UnitStatus.diperiksa);
        simulator.hydrate('bk1', '-B', UnitStatus.terjadwal);
        simulator.hydrate('bk1', '-C', UnitStatus.selesai);
        async.elapse(const Duration(seconds: 5));

        expect(transitions.map((t) => (t.unitCode, t.status)), [
          ('-A', UnitStatus.dikerjakan),
        ]);
        simulator.dispose();
      });
    });

    test('transitions emit for advance, reset and timer ticks', () {
      fakeAsync((async) {
        final simulator = TrackingSimulator(
          demoModeController: DemoModeController()
            ..setTrackingSpeed(TrackingSpeed.detik5),
        );
        final statuses = <UnitStatus>[];
        simulator.transitions.listen((t) => statuses.add(t.status));

        simulator.advance('bk1', '-A'); // -> checkIn, schedules a tick
        async.elapse(const Duration(seconds: 5)); // -> diperiksa
        simulator.reset('bk1', '-A');

        expect(statuses, [
          UnitStatus.checkIn,
          UnitStatus.diperiksa,
          UnitStatus.terjadwal,
        ]);
        simulator.dispose();
      });
    });
  });
}
