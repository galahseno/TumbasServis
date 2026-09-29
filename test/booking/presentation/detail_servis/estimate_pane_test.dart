import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tumbas_servis/app/app_theme.dart';
import 'package:tumbas_servis/booking/presentation/detail_servis/components/estimate_pane.dart';
import 'package:tumbas_servis/core/presentation/components/ts_button.dart';

void main() {
  Widget host({VoidCallback? onContinue, String? reasonLine}) => MaterialApp(
    theme: AppTheme.light,
    home: Scaffold(
      body: Align(
        alignment: Alignment.topLeft,
        child: SizedBox(
          width: 360,
          child: EstimatePane(
            lines: const [
              EstimatePaneLine(label: 'Vario 125', subtotal: 85000),
              EstimatePaneLine(label: 'PCX 160'),
            ],
            totalLabel: 'Rp85.000',
            durationLabel: 'Estimasi · 1 jam',
            reasonLine: reasonLine,
            onContinue: onContinue,
          ),
        ),
      ),
    ),
  );

  testWidgets('lists each unit statically; unpicked unit says Belum dipilih', (
    tester,
  ) async {
    await tester.pumpWidget(host(onContinue: () {}));

    expect(find.text('Estimasi biaya'), findsOneWidget);
    expect(find.text('Vario 125'), findsOneWidget);
    expect(find.text('Rp85.000'), findsNWidgets(2)); // unit line + total
    expect(find.text('Belum dipilih'), findsOneWidget);
    expect(find.text('Estimasi · 1 jam'), findsOneWidget);
  });

  testWidgets('Lanjut is disabled with a reason until every unit is ready', (
    tester,
  ) async {
    await tester.pumpWidget(host(reasonLine: 'Pilih layanan untuk PCX 160'));

    expect(find.text('Pilih layanan untuk PCX 160'), findsOneWidget);
    expect(tester.widget<TsButton>(find.byType(TsButton)).onPressed, isNull);
  });

  testWidgets('Lanjut fires onContinue when enabled', (tester) async {
    var continued = 0;
    await tester.pumpWidget(host(onContinue: () => continued++));

    await tester.tap(find.text('Lanjut'));
    expect(continued, 1);
  });
}
