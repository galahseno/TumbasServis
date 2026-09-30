import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tumbas_servis/app/app_theme.dart';
import 'package:tumbas_servis/core/presentation/components/adaptive_sheet.dart';
import 'package:tumbas_servis/core/presentation/components/sheet_header.dart';

void main() {
  Future<void> open(WidgetTester tester, Size size) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Builder(
          builder: (context) => Scaffold(
            body: TextButton(
              onPressed: () => showAdaptiveSheet<void>(
                context,
                builder: (context) => const SheetHeader(title: 'Judul sheet'),
              ),
              child: const Text('buka'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('buka'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
  }

  testWidgets('compact: a bottom sheet with the drag handle', (tester) async {
    await open(tester, const Size(393, 852));

    expect(find.byType(BottomSheet), findsOneWidget);
    expect(find.byType(Dialog), findsNothing);
    expect(find.text('Judul sheet'), findsOneWidget);
  });

  testWidgets('tablet: a centered modal capped at 560 without a handle', (
    tester,
  ) async {
    await open(tester, const Size(1280, 800));

    expect(find.byType(BottomSheet), findsNothing);
    expect(find.byType(Dialog), findsOneWidget);
    final surface = tester.getRect(
      find
          .descendant(of: find.byType(Dialog), matching: find.byType(Material))
          .first,
    );
    expect(surface.width, lessThanOrEqualTo(560));
    expect(surface.center.dx, closeTo(640, 1));
  });
}
