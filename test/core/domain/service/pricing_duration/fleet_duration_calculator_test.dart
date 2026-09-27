import 'package:flutter_test/flutter_test.dart';
import 'package:tumbas_servis/core/domain/model/catalog/service_type.dart';
import 'package:tumbas_servis/core/domain/service/pricing_duration/fleet_duration_calculator.dart';

const _servisBerkala = ServiceType(
  id: 'svc-servis-berkala',
  name: 'Servis Berkala',
  price: 85000,
  durationMin: 60,
  requiresComplaint: false,
);

void main() {
  const calculator = FleetDurationCalculator();

  test('unitDurationMin sums selected services durations', () {
    expect(calculator.unitDurationMin([_servisBerkala]), 60);
    expect(calculator.unitDurationMin([_servisBerkala, _servisBerkala]), 120);
    expect(calculator.unitDurationMin([]), 0);
  });

  test(
    '3 units of 60min on 2 bays makespans to 120min, not the naive 180min sum',
    () {
      final makespan = calculator.sharedMakespanMin(
        unitDurationsMin: [60, 60, 60],
        bayCount: 2,
      );
      expect(makespan, 120);
      expect(makespan, isNot(180));
    },
  );

  test('split mode uses per-unit duration only, never a fleet makespan', () {
    final unitADuration = calculator.unitDurationMin([_servisBerkala]);
    final unitBDuration = calculator.unitDurationMin([
      _servisBerkala,
      _servisBerkala,
    ]);

    expect(unitADuration, 60);
    expect(unitBDuration, 120);
  });
}
