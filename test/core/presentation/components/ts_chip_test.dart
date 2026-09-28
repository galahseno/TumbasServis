import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tumbas_servis/app/app_theme.dart';
import 'package:tumbas_servis/core/presentation/components/ts_chip.dart';

Widget _wrap(Widget child) => MaterialApp(
  theme: AppTheme.light,
  home: Scaffold(body: child),
);

void main() {
  testWidgets('selected chip shows the leading check icon', (tester) async {
    await tester.pumpWidget(
      _wrap(TsChip(label: 'Matic', selected: true, onSelected: (_) {})),
    );
    expect(find.byIcon(Icons.check_rounded), findsOneWidget);
  });

  testWidgets('unselected chip has no check icon', (tester) async {
    await tester.pumpWidget(
      _wrap(TsChip(label: 'Matic', selected: false, onSelected: (_) {})),
    );
    expect(find.byIcon(Icons.check_rounded), findsNothing);
  });

  testWidgets('disabled chip ignores tap', (tester) async {
    var called = false;
    await tester.pumpWidget(
      _wrap(
        TsChip(
          label: 'Matic',
          selected: false,
          onSelected: (_) => called = true,
        ),
      ),
    );
    // Rebuild as disabled (onSelected: null) and confirm tapping is a no-op.
    await tester.pumpWidget(
      _wrap(const TsChip(label: 'Matic', selected: false)),
    );
    await tester.tap(find.byType(TsChip));
    await tester.pump();
    expect(called, isFalse);
  });
}
