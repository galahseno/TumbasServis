import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tumbas_servis/app/app_theme.dart';
import 'package:tumbas_servis/booking/presentation/components/unit_rail.dart';
import 'package:tumbas_servis/booking/presentation/utils/unit_config_display.dart';

void main() {
  testWidgets('one row per unit, tap selects, long text never overflows', (
    tester,
  ) async {
    final selected = <String>[];
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: Align(
            alignment: Alignment.topLeft,
            child: SizedBox(
              width: UnitRail.width,
              child: UnitRail(
                activeId: 'a',
                onSelect: selected.add,
                items: const [
                  UnitRailItem(
                    id: 'a',
                    title: 'Vario 125 Kesayangan Keluarga Besar Sekali',
                    subtitle: 'AB 1234 XY · lengkap dan siap dilanjutkan',
                    status: UnitChipStatus.complete,
                  ),
                  UnitRailItem(
                    id: 'b',
                    title: 'PCX 160',
                    subtitle: 'AB 9012 QR · belum lengkap',
                    status: UnitChipStatus.incomplete,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(find.text('Motor'), findsOneWidget);
    await tester.tap(find.text('PCX 160'));
    expect(selected, ['b']);
    expect(tester.getSize(find.text('PCX 160')).height, lessThanOrEqualTo(62));
  });
}
