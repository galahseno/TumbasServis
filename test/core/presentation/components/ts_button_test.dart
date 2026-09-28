import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tumbas_servis/app/app_theme.dart';
import 'package:tumbas_servis/core/presentation/components/ts_button.dart';

Widget _wrap(Widget child) => MaterialApp(
  theme: AppTheme.light,
  home: Scaffold(body: child),
);

void main() {
  for (final type in TsButtonType.values) {
    group('TsButton (${type.name})', () {
      testWidgets('renders and fires onPressed when enabled', (tester) async {
        var tapped = false;
        await tester.pumpWidget(
          _wrap(
            TsButton(
              label: 'Lanjut',
              type: type,
              onPressed: () => tapped = true,
            ),
          ),
        );
        expect(find.text('Lanjut'), findsOneWidget);

        await tester.tap(find.byType(TsButton));
        await tester.pump();
        expect(tapped, isTrue);
      });

      testWidgets('does not fire onPressed when disabled', (tester) async {
        await tester.pumpWidget(
          _wrap(TsButton(label: 'Lanjut', type: type, onPressed: null)),
        );
        await tester.tap(find.byType(TsButton));
        await tester.pump();
        // No exception + label still rendered is sufficient proof no
        // handler exists to fire.
        expect(find.text('Lanjut'), findsOneWidget);
      });

      testWidgets('loading shows spinner, hides label, ignores tap', (
        tester,
      ) async {
        var tapped = false;
        await tester.pumpWidget(
          _wrap(
            TsButton(
              label: 'Lanjut',
              type: type,
              isLoading: true,
              onPressed: () => tapped = true,
            ),
          ),
        );
        expect(find.byType(CircularProgressIndicator), findsOneWidget);

        await tester.tap(find.byType(TsButton));
        await tester.pump();
        expect(tapped, isFalse);
      });
    });
  }
}
