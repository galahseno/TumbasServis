import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tumbas_servis/app/app_theme.dart';
import 'package:tumbas_servis/booking/presentation/voucher/components/voucher_card.dart';

void main() {
  testWidgets('selecting a voucher has no ripple (no InkWell) and still '
      'fires onTap', (tester) async {
    var taps = 0;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: VoucherCard(
            title: 'Diskon 10%',
            subtitle: 'Kode DISKON10',
            selected: false,
            savingLabel: 'Hemat Rp42.800',
            onTap: () => taps++,
          ),
        ),
      ),
    );

    expect(find.byType(InkWell), findsNothing);
    expect(find.byType(InkResponse), findsNothing);

    await tester.tap(find.text('Diskon 10%'));
    await tester.pump();

    expect(taps, 1);
  });
}
