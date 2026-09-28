import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tumbas_servis/app/app_theme.dart';
import 'package:tumbas_servis/core/domain/model/booking/unit_status.dart';
import 'package:tumbas_servis/core/presentation/components/unit_status_badge.dart';

Widget _wrap(Widget child) => MaterialApp(
  theme: AppTheme.light,
  home: Scaffold(body: child),
);

void main() {
  const expectedLabels = {
    UnitStatus.terjadwal: 'Terjadwal',
    UnitStatus.checkIn: 'Check-in / Antre',
    UnitStatus.diperiksa: 'Diperiksa',
    UnitStatus.dikerjakan: 'Dikerjakan',
    UnitStatus.qc: 'QC',
    UnitStatus.selesai: 'Selesai',
    UnitStatus.dibatalkan: 'Dibatalkan',
  };

  for (final entry in expectedLabels.entries) {
    testWidgets('${entry.key.name} renders an icon and its label', (
      tester,
    ) async {
      await tester.pumpWidget(_wrap(UnitStatusBadge(status: entry.key)));

      expect(find.text(entry.value), findsOneWidget);
      expect(find.byType(Icon), findsOneWidget);
    });
  }
}
