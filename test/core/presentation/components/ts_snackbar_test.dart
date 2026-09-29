import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tumbas_servis/app/app_theme.dart';
import 'package:tumbas_servis/core/presentation/components/ts_snackbar.dart';

Future<void> _pump(
  WidgetTester tester,
  void Function(BuildContext) show,
) async {
  await tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.light,
      home: Scaffold(
        body: Builder(
          builder: (context) => TextButton(
            onPressed: () => show(context),
            child: const Text('go'),
          ),
        ),
      ),
    ),
  );
  await tester.tap(find.text('go'));
  await tester.pump();
}

void main() {
  testWidgets('a snackbar with an action auto-dismisses (does not persist)', (
    tester,
  ) async {
    await _pump(
      tester,
      (context) => TsSnackbar.info(
        context,
        'Disalin dari Vario 125',
        actionLabel: 'Urungkan',
        onAction: () {},
      ),
    );
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('Disalin dari Vario 125'), findsOneWidget);

    await tester.pump(const Duration(seconds: 7));
    await tester.pumpAndSettle();

    expect(find.text('Disalin dari Vario 125'), findsNothing);
  });

  testWidgets('a plain snackbar auto-dismisses after 4s', (tester) async {
    await _pump(tester, (context) => TsSnackbar.success(context, 'Selesai'));
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('Selesai'), findsOneWidget);

    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();

    expect(find.text('Selesai'), findsNothing);
  });

  testWidgets('a new snackbar replaces the current one instead of queueing', (
    tester,
  ) async {
    await _pump(tester, (context) {
      TsSnackbar.info(context, 'Pertama');
      TsSnackbar.info(context, 'Kedua');
    });
    await tester.pumpAndSettle(const Duration(seconds: 1));

    expect(find.text('Pertama'), findsNothing);
    expect(find.text('Kedua'), findsOneWidget);
  });
}
