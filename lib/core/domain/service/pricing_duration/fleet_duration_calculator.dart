import 'package:tumbas_servis/core/domain/model/catalog/service_type.dart';

class FleetDurationCalculator {
  const FleetDurationCalculator();

  int unitDurationMin(List<ServiceType> selectedServices) =>
      selectedServices.fold<int>(0, (sum, s) => sum + s.durationMin);

  int sharedMakespanMin({
    required List<int> unitDurationsMin,
    required int bayCount,
  }) {
    if (unitDurationsMin.isEmpty || bayCount <= 0) return 0;
    final bayLoads = List<int>.filled(bayCount, 0);
    final sorted = List<int>.of(unitDurationsMin)
      ..sort((a, b) => b.compareTo(a));
    for (final duration in sorted) {
      var minIndex = 0;
      for (var i = 1; i < bayLoads.length; i++) {
        if (bayLoads[i] < bayLoads[minIndex]) minIndex = i;
      }
      bayLoads[minIndex] += duration;
    }
    return bayLoads.reduce((a, b) => a > b ? a : b);
  }
}
