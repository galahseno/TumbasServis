import 'package:tumbas_servis/booking/presentation/utils/schedule_display.dart';
import 'package:tumbas_servis/booking/presentation/utils/unit_config_display.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking_draft.dart';
import 'package:tumbas_servis/core/domain/model/catalog/part.dart';
import 'package:tumbas_servis/core/domain/model/catalog/service_type.dart';
import 'package:tumbas_servis/core/domain/model/garage/motor.dart';
import 'package:tumbas_servis/core/domain/service/pricing_duration/fleet_duration_calculator.dart';
import 'package:tumbas_servis/core/domain/service/pricing_duration/pricing_calculator.dart';

const _pricingCalculator = PricingCalculator();
const _fleetDurationCalculator = FleetDurationCalculator();

class RingkasanUnitLine {
  const RingkasanUnitLine({
    required this.motorId,
    required this.motor,
    required this.services,
    required this.parts,
    required this.complaintNote,
    required this.subtotal,
    required this.durationMin,
  });

  final String motorId;
  final Motor motor;
  final List<ServiceType> services;
  final List<Part> parts;
  final String? complaintNote;
  final int subtotal;
  final int durationMin;
}

List<RingkasanUnitLine> buildUnitLines({
  required BookingDraft draft,
  required Map<String, Motor> motorsById,
  required Map<String, ServiceType> serviceById,
  required Map<String, Part> partById,
}) {
  final lines = <RingkasanUnitLine>[];
  for (final motorId in draft.selectedMotorIds) {
    final motor = motorsById[motorId];
    if (motor == null) continue;
    final config = draft.unitConfigs[motorId] ?? emptyUnitConfig();
    final services = selectedServiceTypesFor(
      config,
      serviceById.values.toList(),
    );
    final parts = config.partIds
        .map((id) => partById[id])
        .whereType<Part>()
        .toList();
    lines.add(
      RingkasanUnitLine(
        motorId: motorId,
        motor: motor,
        services: services,
        parts: parts,
        complaintNote: config.complaintNote,
        subtotal: _pricingCalculator.unitSubtotal(
          services: services,
          parts: parts,
        ),
        durationMin: _fleetDurationCalculator.unitDurationMin(services),
      ),
    );
  }
  return lines;
}

String unitServiceSummary(RingkasanUnitLine line) {
  if (line.services.isEmpty) return '';
  final label = line.services.map((s) => s.name).join(', ');
  if (line.parts.isEmpty) return label;
  return '$label + ${line.parts.length} suku cadang';
}

String estimateDurationCaption({
  required BookingDraft draft,
  required List<RingkasanUnitLine> units,
  required int bayCount,
}) {
  if (units.isEmpty) return '';
  if (draft.scheduleMode == ScheduleMode.split) {
    final maxDuration = units
        .map((u) => u.durationMin)
        .reduce((a, b) => a > b ? a : b);
    return 'Estimasi ${formatEstimateDuration(maxDuration)} per motor · '
        'datang di jam berbeda';
  }
  if (units.length == 1) {
    return 'Estimasi ${formatEstimateDuration(units.first.durationMin)}';
  }
  final makespan = _fleetDurationCalculator.sharedMakespanMin(
    unitDurationsMin: units.map((u) => u.durationMin).toList(),
    bayCount: bayCount,
  );
  return 'Estimasi ${formatEstimateDuration(makespan)} · dikerjakan '
      'bergantian di $bayCount bay';
}

String jadwalSummaryLine(BookingDraft draft, Map<String, Motor> motorsById) {
  if (draft.scheduleMode == ScheduleMode.split) {
    return draft.selectedMotorIds
        .map((id) {
          final slot = draft.unitSlots[id];
          final nickname = motorsById[id]?.nickname ?? id;
          return slot == null
              ? nickname
              : '$nickname · ${slotRecapLabel(slot)}';
        })
        .join('\n');
  }
  final slot = draft.sharedSlot;
  return slot == null ? '' : slotRecapLabel(slot);
}
