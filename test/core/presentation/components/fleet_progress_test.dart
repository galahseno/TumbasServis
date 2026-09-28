import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tumbas_servis/app/app_theme.dart';
import 'package:tumbas_servis/core/domain/model/booking/unit_status.dart';
import 'package:tumbas_servis/core/presentation/components/fleet_progress.dart';

void main() {
  testWidgets('renders one segment per unit and the mandatory text label', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: FleetProgress(
            unitStatuses: const [
              UnitStatus.dikerjakan,
              UnitStatus.dikerjakan,
              UnitStatus.diperiksa,
            ],
            label: 'Motor 1 dari 3: Dikerjakan',
          ),
        ),
      ),
    );

    expect(find.byType(FleetProgressSegment), findsNWidgets(3));
    expect(find.text('Motor 1 dari 3: Dikerjakan'), findsOneWidget);
  });

  for (final count in [1, 3, 5]) {
    testWidgets('renders $count segments for $count units', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: Scaffold(
            body: FleetProgress(
              unitStatuses: List.filled(count, UnitStatus.terjadwal),
              label: 'label',
            ),
          ),
        ),
      );

      expect(find.byType(FleetProgressSegment), findsNWidgets(count));
    });
  }

  test('UnitStatus.stageIndex maps the forward stages 0-5', () {
    expect(UnitStatus.terjadwal.stageIndex, 0);
    expect(UnitStatus.checkIn.stageIndex, 1);
    expect(UnitStatus.diperiksa.stageIndex, 2);
    expect(UnitStatus.dikerjakan.stageIndex, 3);
    expect(UnitStatus.qc.stageIndex, 4);
    expect(UnitStatus.selesai.stageIndex, 5);
    expect(UnitStatus.dibatalkan.stageIndex, 0);
    expect(UnitStatus.unknown.stageIndex, 0);
  });
}
