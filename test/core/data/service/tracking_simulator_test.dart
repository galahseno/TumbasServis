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
}
