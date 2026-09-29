import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:tumbas_servis/app/app_theme.dart';
import 'package:tumbas_servis/booking/presentation/pilih_jadwal/components/date_grid.dart';
import 'package:tumbas_servis/booking/presentation/pilih_jadwal/components/date_grid_cell.dart';

void main() {
  setUpAll(() async {
    await initializeDateFormatting('id_ID', null);
  });

  final today = DateTime(2026, 9, 29);

  Future<List<DateTime>> pumpGrid(WidgetTester tester) async {
    final tapped = <DateTime>[];
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: SizedBox(
            width: 480,
            child: DateGrid(
              today: today,
              selectedDate: today,
              windowDays: 14,
              onSelect: tapped.add,
            ),
          ),
        ),
      ),
    );
    return tapped;
  }

  testWidgets('7 columns × 3 rows, today in its weekday column', (
    tester,
  ) async {
    await pumpGrid(tester);

    expect(find.byType(DateGridCell), findsNWidgets(21));
    for (final label in ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min']) {
      expect(find.text(label), findsOneWidget, reason: label);
    }
    expect(find.text('Sep – Okt 2026'), findsOneWidget);

    final gridLeft = tester.getTopLeft(find.byType(DateGrid)).dx;
    final todayLeft = tester
        .getTopLeft(find.bySemanticsLabel(RegExp('Hari ini')))
        .dx;
    expect(todayLeft, greaterThan(gridLeft + 16));
  });

  testWidgets('only D+0…D+14 are tappable; blanks outside are not', (
    tester,
  ) async {
    final tapped = await pumpGrid(tester);

    await tester.tap(find.text('13'));
    await tester.tap(find.text('30'));
    expect(tapped, [DateTime(2026, 10, 13), DateTime(2026, 9, 30)]);

    expect(find.text('28'), findsNothing);
    expect(find.text('14'), findsNothing);
  });

  testWidgets('cells keep a 48dp tap target', (tester) async {
    await pumpGrid(tester);

    final size = tester.getSize(find.byType(DateGridCell).at(2));
    expect(size.height, greaterThanOrEqualTo(48));
    expect(size.width, greaterThanOrEqualTo(48));
  });
}
