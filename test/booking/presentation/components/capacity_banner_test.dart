import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tumbas_servis/app/app_theme.dart';
import 'package:tumbas_servis/booking/presentation/components/capacity_banner.dart';

void main() {
  testWidgets('a single action renders and fires', (tester) async {
    var tapped = false;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: CapacityBanner(
            tone: CapacityBannerTone.warning,
            title: 'Kapasitas tidak cukup',
            actionLabel: 'Pisah jadwal',
            onAction: () => tapped = true,
          ),
        ),
      ),
    );

    await tester.tap(find.text('Pisah jadwal'));
    expect(tapped, isTrue);
    expect(find.text('Pilih jam lain'), findsNothing);
  });

  testWidgets(
    'a second action renders alongside the first and fires independently',
    (tester) async {
      var firstTapped = false;
      var secondTapped = false;
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: Scaffold(
            body: CapacityBanner(
              tone: CapacityBannerTone.warning,
              title: 'Jam 09.00 sudah tidak muat 3 motor',
              body: 'Tersisa 2 motor di Sel, 29 Sep · 09.00.',
              actionLabel: 'Pisah jadwal',
              onAction: () => firstTapped = true,
              actionLabel2: 'Pilih jam lain',
              onAction2: () => secondTapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.text('Pisah jadwal'));
      expect(firstTapped, isTrue);
      expect(secondTapped, isFalse);

      await tester.tap(find.text('Pilih jam lain'));
      expect(secondTapped, isTrue);
    },
  );
}
