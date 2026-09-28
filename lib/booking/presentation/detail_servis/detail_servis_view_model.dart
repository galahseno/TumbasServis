import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tumbas_servis/booking/presentation/detail_servis/state/detail_servis_state.dart';
import 'package:tumbas_servis/booking/presentation/di/booking_presentation_module.dart';
import 'package:tumbas_servis/booking/presentation/utils/unit_config_display.dart';
import 'package:tumbas_servis/catalog/data/di/catalog_data_module.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking_draft.dart';
import 'package:tumbas_servis/core/domain/model/catalog/part.dart';
import 'package:tumbas_servis/core/domain/model/catalog/service_type.dart';
import 'package:tumbas_servis/core/domain/model/garage/motor.dart';
import 'package:tumbas_servis/core/domain/model/result.dart';
import 'package:tumbas_servis/core/domain/service/pricing_duration/fleet_duration_calculator.dart';
import 'package:tumbas_servis/core/domain/service/pricing_duration/pricing_calculator.dart';
import 'package:tumbas_servis/core/domain/service/unit_config/salin_dari_compatibility_filter.dart';
import 'package:tumbas_servis/garage/data/di/garage_data_module.dart';

const detailServisBayCount = 2;

class DetailServisViewModel extends Notifier<DetailServisState> {
  static const _pricing = PricingCalculator();
  static const _duration = FleetDurationCalculator();
  static const _copyFilter = SalinDariCompatibilityFilter();

  final Map<String, UnitConfig?> _preCopySnapshots = {};

  @override
  DetailServisState build() {
    _load();
    return const DetailServisState();
  }

  Future<void> retry() async {
    state = state.copyWith(isLoading: true, hasError: false);
    await _load();
  }

  Future<void> _load() async {
    final catalogRepo = ref.read(catalogRepositoryProvider);
    final garageRepo = ref.read(garageRepositoryProvider);

    final servicesResult = await catalogRepo.getServiceTypes();
    if (!ref.mounted) return;
    if (servicesResult is Error<List<ServiceType>>) {
      state = state.copyWith(isLoading: false, hasError: true);
      return;
    }

    final partsResult = await catalogRepo.getParts();
    if (!ref.mounted) return;
    if (partsResult is Error<List<Part>>) {
      state = state.copyWith(isLoading: false, hasError: true);
      return;
    }

    final motorsResult = await garageRepo.getMotors();
    if (!ref.mounted) return;
    if (motorsResult is Error<List<Motor>>) {
      state = state.copyWith(isLoading: false, hasError: true);
      return;
    }

    state = state.copyWith(
      isLoading: false,
      hasError: false,
      serviceTypes: (servicesResult as Ok<List<ServiceType>>).value,
      parts: (partsResult as Ok<List<Part>>).value,
      motorsById: {
        for (final motor in (motorsResult as Ok<List<Motor>>).value)
          motor.id: motor,
      },
    );
  }

  void setActiveMotor(String motorId) {
    state = state.copyWith(activeMotorId: motorId);
  }

  void toggleComplaintExpanded(String motorId) {
    final expanded = {...state.manuallyExpandedComplaintMotorIds};
    if (!expanded.add(motorId)) expanded.remove(motorId);
    state = state.copyWith(manuallyExpandedComplaintMotorIds: expanded);
  }

  List<Part> partsForModel(String modelId) => state.parts
      .where((part) => part.compatibleModelIds.contains(modelId))
      .toList();

  int unitSubtotal(UnitConfig config) => _pricing.unitSubtotal(
    services: selectedServiceTypesFor(config, state.serviceTypes),
    parts: state.parts
        .where((part) => config.partIds.contains(part.id))
        .toList(),
  );

  int unitDurationMin(UnitConfig config) => _duration.unitDurationMin(
    selectedServiceTypesFor(config, state.serviceTypes),
  );

  PriceBreakdown fleetPriceBreakdown(BookingDraft draft) {
    final subtotals = [
      for (final motorId in draft.selectedMotorIds)
        unitSubtotal(draft.unitConfigs[motorId] ?? emptyUnitConfig()),
    ];
    return _pricing.breakdown(unitSubtotals: subtotals);
  }

  int fleetDurationMin(BookingDraft draft) {
    final durations = [
      for (final motorId in draft.selectedMotorIds)
        unitDurationMin(draft.unitConfigs[motorId] ?? emptyUnitConfig()),
    ];
    return _duration.sharedMakespanMin(
      unitDurationsMin: durations,
      bayCount: detailServisBayCount,
    );
  }

  Future<void> copyFrom({
    required BookingDraft draft,
    required String sourceMotorId,
    required String targetMotorId,
    required String targetModelId,
  }) async {
    final source = draft.unitConfigs[sourceMotorId] ?? emptyUnitConfig();
    final previous = draft.unitConfigs[targetMotorId];
    final result = _copyFilter.copyTo(
      source: source,
      targetModelId: targetModelId,
      catalogParts: state.parts,
    );

    await ref
        .read(bookingDraftProvider.notifier)
        .setUnitConfig(
          targetMotorId,
          UnitConfig(
            serviceIds: result.serviceIds,
            partIds: result.partIds,
            complaintNote: previous?.complaintNote,
          ),
        );

    _preCopySnapshots[targetMotorId] = previous;
    state = state.copyWith(
      droppedPartsCountByMotor: {
        ...state.droppedPartsCountByMotor,
        targetMotorId: result.droppedIncompatiblePartCount,
      },
    );
  }

  Future<void> undoCopy(String motorId) async {
    if (!_preCopySnapshots.containsKey(motorId)) return;
    final previous = _preCopySnapshots.remove(motorId);
    await ref
        .read(bookingDraftProvider.notifier)
        .setUnitConfig(motorId, previous ?? emptyUnitConfig());
    final dropped = {...state.droppedPartsCountByMotor}..remove(motorId);
    state = state.copyWith(droppedPartsCountByMotor: dropped);
  }
}
