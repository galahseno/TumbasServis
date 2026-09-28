import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tumbas_servis/app/app_theme.dart';
import 'package:tumbas_servis/core/presentation/components/ts_text_field.dart';

Widget _wrap(Widget child) => MaterialApp(
  theme: AppTheme.light,
  home: Scaffold(body: child),
);

void main() {
  testWidgets(
    'error state shows both an icon and the message (never color-only)',
    (tester) async {
      await tester.pumpWidget(
        _wrap(
          const TsTextField(label: 'No. HP', errorText: 'Nomor tidak valid'),
        ),
      );

      expect(find.text('Nomor tidak valid'), findsOneWidget);
      expect(find.byIcon(Icons.error_outline_rounded), findsOneWidget);
    },
  );

  testWidgets('disabled field ignores text entry', (tester) async {
    final controller = TextEditingController();
    await tester.pumpWidget(
      _wrap(
        TsTextField(label: 'No. HP', controller: controller, enabled: false),
      ),
    );

    await tester.enterText(find.byType(TextField), '0812');
    await tester.pump();
    expect(controller.text, isEmpty);
  });

  testWidgets('multiline field shows a counter once text is entered', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(const TsTextField(label: 'Keluhan', maxLines: 4, maxLength: 250)),
    );

    await tester.enterText(find.byType(TextField), 'Bunyi kasar');
    await tester.pump();
    expect(find.text('11/250'), findsOneWidget);
  });
}
