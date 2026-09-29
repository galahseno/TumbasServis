import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tumbas_servis/app/app_theme.dart';
import 'package:tumbas_servis/workshop/presentation/pilih_bengkel/components/filter_chip_row.dart';
import 'package:tumbas_servis/workshop/presentation/pilih_bengkel/state/pilih_bengkel_state.dart';

void main() {
  testWidgets('chips are single-select: tapping one moves the selection', (
    tester,
  ) async {
    var selected = WorkshopFilter.terdekat;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: StatefulBuilder(
            builder: (context, setState) => FilterChipRow(
              selected: selected,
              onSelected: (value) => setState(() => selected = value),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Buka sekarang'));
    await tester.pump();
    expect(selected, WorkshopFilter.bukaSekarang);

    await tester.tap(find.text('Rating tertinggi'));
    await tester.pump();
    expect(selected, WorkshopFilter.ratingTertinggi);

    await tester.tap(find.text('Rating tertinggi'));
    await tester.pump();
    expect(selected, WorkshopFilter.ratingTertinggi);
  });
}
