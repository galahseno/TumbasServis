import 'package:flutter_test/flutter_test.dart';
import 'package:tumbas_servis/core/data/service/demo_mode_controller.dart';

void main() {
  test('consumeArmedError is false until armed, then fires once', () {
    final controller = DemoModeController();

    expect(controller.consumeArmedError(), isFalse);

    controller.armNextWriteError();
    expect(controller.consumeArmedError(), isTrue);
    expect(controller.consumeArmedError(), isFalse);

    controller.dispose();
  });

  test('trackingSpeed defaults to detik15 and is settable', () {
    final controller = DemoModeController();

    expect(controller.trackingSpeed, TrackingSpeed.detik15);
    controller.setTrackingSpeed(TrackingSpeed.mati);
    expect(controller.trackingSpeed, TrackingSpeed.mati);

    controller.dispose();
  });

  test('requestReset emits on resetRequests', () async {
    final controller = DemoModeController();
    final events = <void>[];
    final subscription = controller.resetRequests.listen(events.add);

    controller.requestReset();
    await Future<void>.delayed(Duration.zero);

    expect(events, hasLength(1));

    await subscription.cancel();
    controller.dispose();
  });
}
