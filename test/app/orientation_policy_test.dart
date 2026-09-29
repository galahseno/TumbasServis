import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tumbas_servis/app/orientation_policy.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('preferredOrientationsFor', () {
    test('phone display is portrait-locked', () {
      expect(preferredOrientationsFor(const Size(412, 915)), [
        DeviceOrientation.portraitUp,
      ]);
      expect(preferredOrientationsFor(const Size(915, 412)), [
        DeviceOrientation.portraitUp,
      ]);
    });

    test('tablet display rotates freely', () {
      expect(
        preferredOrientationsFor(const Size(800, 1280)),
        DeviceOrientation.values,
      );
      expect(
        preferredOrientationsFor(const Size(1280, 800)),
        DeviceOrientation.values,
      );
    });
  });

  group('OrientationPolicy widget', () {
    late List<MethodCall> calls;

    setUp(() {
      calls = [];
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(SystemChannels.platform, (call) async {
            if (call.method == 'SystemChrome.setPreferredOrientations') {
              calls.add(call);
            }
            return null;
          });
    });

    tearDown(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(SystemChannels.platform, null);
    });

    testWidgets('locks portrait on a phone display', (tester) async {
      tester.view.display.size = const Size(412, 915);
      tester.view.display.devicePixelRatio = 1;
      addTearDown(tester.view.display.reset);

      await tester.pumpWidget(
        const OrientationPolicy(child: SizedBox.shrink()),
      );

      expect(calls, hasLength(1));
      expect(calls.single.arguments, ['DeviceOrientation.portraitUp']);
    });

    testWidgets('unlocks all orientations on a tablet display', (tester) async {
      tester.view.display.size = const Size(800, 1280);
      tester.view.display.devicePixelRatio = 1;
      addTearDown(tester.view.display.reset);

      await tester.pumpWidget(
        const OrientationPolicy(child: SizedBox.shrink()),
      );

      expect(calls, hasLength(1));
      expect(
        (calls.single.arguments as List).length,
        DeviceOrientation.values.length,
      );
    });
  });
}
