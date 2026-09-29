import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tumbas_servis/core/presentation/utils/window_size_class.dart';

void main() {
  group('WindowSizeClass.fromWidth', () {
    test('picks the class at each PRD 06 breakpoint', () {
      expect(WindowSizeClass.fromWidth(360), WindowSizeClass.compact);
      expect(WindowSizeClass.fromWidth(599), WindowSizeClass.compact);
      expect(WindowSizeClass.fromWidth(600), WindowSizeClass.medium);
      expect(WindowSizeClass.fromWidth(800), WindowSizeClass.medium);
      expect(WindowSizeClass.fromWidth(839), WindowSizeClass.medium);
      expect(WindowSizeClass.fromWidth(840), WindowSizeClass.expanded);
      expect(WindowSizeClass.fromWidth(1024), WindowSizeClass.expanded);
      expect(WindowSizeClass.fromWidth(1199), WindowSizeClass.expanded);
      expect(WindowSizeClass.fromWidth(1200), WindowSizeClass.large);
      expect(WindowSizeClass.fromWidth(1280), WindowSizeClass.large);
    });

    test('isAtLeast orders the classes', () {
      expect(WindowSizeClass.large.isAtLeast(WindowSizeClass.expanded), isTrue);
      expect(
        WindowSizeClass.medium.isAtLeast(WindowSizeClass.expanded),
        isFalse,
      );
      expect(
        WindowSizeClass.compact.isAtLeast(WindowSizeClass.compact),
        isTrue,
      );
    });
  });

  group('isTabletSize', () {
    test('splits phone and tablet on shortestSide 600', () {
      expect(isTabletSize(const Size(412, 915)), isFalse);
      expect(isTabletSize(const Size(599, 1200)), isFalse);
      expect(isTabletSize(const Size(600, 960)), isTrue);
      expect(isTabletSize(const Size(1280, 800)), isTrue);
    });

    test('foldable-like 673x841 is a tablet in the medium class', () {
      expect(isTabletSize(const Size(673, 841)), isTrue);
      expect(WindowSizeClass.fromWidth(673), WindowSizeClass.medium);
    });

    test('tablet in a narrow split-screen window falls to compact', () {
      expect(WindowSizeClass.fromWidth(560), WindowSizeClass.compact);
    });
  });

  group('WindowSizeContext', () {
    testWidgets('reads class and device type from MediaQuery', (tester) async {
      late WindowSizeClass sizeClass;
      late bool tablet;
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(size: Size(1280, 800)),
          child: Builder(
            builder: (context) {
              sizeClass = context.windowSizeClass;
              tablet = context.isTablet;
              return const SizedBox.shrink();
            },
          ),
        ),
      );
      expect(sizeClass, WindowSizeClass.large);
      expect(tablet, isTrue);
    });
  });
}
