import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tumbas_servis/app/app_theme.dart';
import 'package:tumbas_servis/booking/presentation/ringkasan/components/confirm_pane.dart';

void main() {
  Widget host({
    bool enabled = true,
    bool isLoading = false,
    String? reasonLine,
    VoidCallback? onConfirm,
    double height = 700,
  }) => MaterialApp(
    theme: AppTheme.light,
    home: Scaffold(
      body: Align(
        alignment: Alignment.topLeft,
        child: SizedBox(
          width: 360,
          height: height,
          child: ConfirmPane(
            voucherRow: const Text('voucher-row'),
            estimate: const Text('estimate-block'),
            ctaLabel: 'Konfirmasi booking',
            loadingLabel: 'Mengonfirmasi…',
            enabled: enabled,
            isLoading: isLoading,
            reasonLine: reasonLine,
            onConfirm: onConfirm ?? () {},
          ),
        ),
      ),
    ),
  );

  testWidgets('holds voucher row, estimate, payment note and CTA', (
    tester,
  ) async {
    await tester.pumpWidget(host());

    expect(find.text('voucher-row'), findsOneWidget);
    expect(find.text('estimate-block'), findsOneWidget);
    expect(find.text('Bayar di bengkel saat selesai'), findsOneWidget);
    expect(find.text('Konfirmasi booking'), findsOneWidget);
  });

  testWidgets('disabled shows the reason and blocks the CTA', (tester) async {
    var confirmed = 0;
    await tester.pumpWidget(
      host(
        enabled: false,
        reasonLine: 'Pilih jadwal baru untuk lanjut',
        onConfirm: () => confirmed++,
      ),
    );

    expect(find.text('Pilih jadwal baru untuk lanjut'), findsOneWidget);
    await tester.tap(find.text('Konfirmasi booking'), warnIfMissed: false);
    expect(confirmed, 0);
  });

  testWidgets('confirming swaps the label and blocks a second tap', (
    tester,
  ) async {
    var confirmed = 0;
    await tester.pumpWidget(
      host(isLoading: true, onConfirm: () => confirmed++),
    );

    expect(find.text('Mengonfirmasi…'), findsOneWidget);
    await tester.tap(find.text('Mengonfirmasi…'), warnIfMissed: false);
    expect(confirmed, 0);
  });

  testWidgets('short viewport: body scrolls, CTA stays pinned, no overflow', (
    tester,
  ) async {
    await tester.pumpWidget(host(height: 220));

    expect(tester.takeException(), isNull);
    expect(find.text('Konfirmasi booking'), findsOneWidget);
  });
}
