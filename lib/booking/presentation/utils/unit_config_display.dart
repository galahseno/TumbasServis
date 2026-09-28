import 'package:tumbas_servis/core/domain/model/booking/booking_draft.dart';
import 'package:tumbas_servis/core/domain/model/catalog/service_type.dart';
import 'package:tumbas_servis/core/domain/service/unit_config/unit_config_validator.dart';

enum UnitChipStatus { incomplete, error, complete }

const _validator = UnitConfigValidator();

UnitConfig emptyUnitConfig() => const UnitConfig(serviceIds: [], partIds: []);

bool unitConfigHasSelections(UnitConfig config) =>
    config.serviceIds.isNotEmpty || config.partIds.isNotEmpty;

List<ServiceType> selectedServiceTypesFor(
  UnitConfig config,
  List<ServiceType> catalogServices,
) => catalogServices
    .where((service) => config.serviceIds.contains(service.id))
    .toList();

UnitChipStatus unitChipStatus(
  UnitConfig config,
  List<ServiceType> catalogServices,
) {
  if (config.serviceIds.isEmpty) return UnitChipStatus.incomplete;
  final result = _validator.validate(
    config: config,
    selectedServiceTypes: selectedServiceTypesFor(config, catalogServices),
  );
  return result.isValid ? UnitChipStatus.complete : UnitChipStatus.error;
}

bool isComplaintRequired(
  UnitConfig config,
  List<ServiceType> catalogServices,
) => selectedServiceTypesFor(
  config,
  catalogServices,
).any((service) => service.requiresComplaint);

String? lanjutBlockedReason({
  required List<String> selectedMotorIds,
  required Map<String, UnitConfig> unitConfigs,
  required List<ServiceType> catalogServices,
  required String Function(String motorId) nicknameFor,
}) {
  for (final motorId in selectedMotorIds) {
    final config = unitConfigs[motorId] ?? emptyUnitConfig();
    final status = unitChipStatus(config, catalogServices);
    if (status == UnitChipStatus.incomplete) {
      return 'Pilih layanan untuk ${nicknameFor(motorId)}';
    }
    if (status == UnitChipStatus.error) {
      return 'Tulis keluhan untuk ${nicknameFor(motorId)}';
    }
  }
  return null;
}

String formatEstimateDuration(int minutes) {
  final hours = (minutes / 60).ceil();
  return '$hours jam';
}

bool isComplaintExpanded({
  required bool required,
  required bool hasNote,
  required bool manuallyExpanded,
}) => required || hasNote || manuallyExpanded;

String? resolveActiveMotorId(String? stored, List<String> selectedMotorIds) {
  if (stored != null && selectedMotorIds.contains(stored)) return stored;
  return selectedMotorIds.isNotEmpty ? selectedMotorIds.first : null;
}

String unitChipStatusLabel(UnitChipStatus status) => switch (status) {
  UnitChipStatus.complete => 'lengkap',
  UnitChipStatus.incomplete => 'belum lengkap',
  UnitChipStatus.error => 'ada kesalahan',
};

List<String> copySourceCandidates({
  required List<String> selectedMotorIds,
  required Map<String, UnitConfig> unitConfigs,
  required String activeMotorId,
}) => selectedMotorIds
    .where((id) => id != activeMotorId)
    .where(
      (id) => unitConfigHasSelections(unitConfigs[id] ?? emptyUnitConfig()),
    )
    .toList();
