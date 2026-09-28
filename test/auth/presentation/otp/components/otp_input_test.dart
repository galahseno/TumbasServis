import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tumbas_servis/app/app_theme.dart';
import 'package:tumbas_servis/auth/presentation/otp/components/otp_input.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(
    theme: AppTheme.light,
    home: Scaffold(body: child),
  );

  testWidgets('paste fills all 6 cells without auto-verifying', (tester) async {
    String? lastValue;
    await tester.pumpWidget(
      wrap(OtpInput(value: '', onChanged: (v) => lastValue = v)),
    );

    await tester.enterText(find.byType(TextField).first, '123456');
    await tester.pump();

    expect(lastValue, '123456');
    for (var i = 0; i < 6; i++) {
      final field = tester.widget<TextField>(find.byType(TextField).at(i));
      expect(field.controller?.text, '${i + 1}');
    }
  });

  testWidgets('typing a single digit advances focus to the next cell', (
    tester,
  ) async {
    String value = '';
    await tester.pumpWidget(
      StatefulBuilder(
        builder: (context, setState) => wrap(
          OtpInput(value: value, onChanged: (v) => setState(() => value = v)),
        ),
      ),
    );

    await tester.enterText(find.byType(TextField).first, '5');
    await tester.pump();

    expect(value, '5');
    expect(
      FocusScope.of(tester.element(find.byType(TextField).at(1))).focusedChild,
      isNotNull,
    );
  });
}
