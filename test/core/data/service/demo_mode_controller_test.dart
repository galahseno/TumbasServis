import 'package:flutter_test/flutter_test.dart';
import 'package:tumbas_servis/core/data/service/demo_mode_controller.dart';

void main() {
  test('consumeArmedError is false until armed, then fires once', () {
    final controller = DemoModeController();

    expect(controller.consumeArmedError(), isFalse);

    controller.armNextWriteError();
    expect(controller.isErrorArmed, isTrue);
    expect(controller.consumeArmedError(), isTrue);
    expect(controller.consumeArmedError(), isFalse);
    expect(controller.isErrorArmed, isFalse);

    controller.dispose();
  });

  test('armedChanges emits on arm, consume and disarm', () {
    final controller = DemoModeController();
    final events = <bool>[];
    final subscription = controller.armedChanges.listen(events.add);

    controller.armNextWriteError();
    controller.consumeArmedError();
    controller.armNextWriteError();
    controller.disarmError();
    controller.disarmError();

    expect(events, [true, false, true, false]);

    subscription.cancel();
    controller.dispose();
  });

  test('trackingSpeed defaults to detik15 and is settable', () {
    final controller = DemoModeController();

    expect(controller.trackingSpeed, TrackingSpeed.detik15);
    controller.setTrackingSpeed(TrackingSpeed.mati);
    expect(controller.trackingSpeed, TrackingSpeed.mati);

    controller.dispose();
  });

  test('speedChanges emits only when the speed actually changes', () {
    final controller = DemoModeController();
    final events = <TrackingSpeed>[];
    final subscription = controller.speedChanges.listen(events.add);

    controller.setTrackingSpeed(TrackingSpeed.detik15);
    controller.setTrackingSpeed(TrackingSpeed.detik5);
    controller.setTrackingSpeed(TrackingSpeed.mati);

    expect(events, [TrackingSpeed.detik5, TrackingSpeed.mati]);

    subscription.cancel();
    controller.dispose();
  });

  test('seeding is a re-entrant flag', () {
    final controller = DemoModeController();
    expect(controller.isSeeding, isFalse);

    controller.beginSeeding();
    controller.beginSeeding();
    controller.endSeeding();
    expect(controller.isSeeding, isTrue);

    controller.endSeeding();
    controller.endSeeding(); // extra end never goes negative
    expect(controller.isSeeding, isFalse);

    controller.dispose();
  });
}
