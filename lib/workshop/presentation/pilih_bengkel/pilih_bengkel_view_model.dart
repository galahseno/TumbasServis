import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tumbas_servis/booking/presentation/utils/unit_config_display.dart';
import 'package:tumbas_servis/catalog/data/di/catalog_data_module.dart';
import 'package:tumbas_servis/core/data/di/core_data_module.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking_draft.dart';
import 'package:tumbas_servis/core/domain/model/catalog/service_type.dart';
import 'package:tumbas_servis/core/domain/model/result.dart';
import 'package:tumbas_servis/core/domain/model/workshop/workshop.dart';
import 'package:tumbas_servis/core/domain/service/pricing_duration/fleet_duration_calculator.dart';
import 'package:tumbas_servis/workshop/data/di/workshop_data_module.dart';
import 'package:tumbas_servis/workshop/presentation/pilih_bengkel/state/pilih_bengkel_state.dart';
import 'package:tumbas_servis/workshop/presentation/utils/workshop_status_display.dart';

class PilihBengkelViewModel extends Notifier<PilihBengkelState> {
  static const _duration = FleetDurationCalculator();

  @override
  PilihBengkelState build() {
    _load(openNowOnly: false);
    return const PilihBengkelState();
  }

  Future<void> refresh() async {
    state = state.copyWith(isLoading: true, hasError: false);
    await _load(openNowOnly: state.filter == WorkshopFilter.bukaSekarang);
  }

  Future<void> setFilter(WorkshopFilter filter) async {
    if (filter == state.filter) return;
    final reload =
        (filter == WorkshopFilter.bukaSekarang) !=
        (state.filter == WorkshopFilter.bukaSekarang);
    state = state.copyWith(filter: filter, isLoading: reload, hasError: false);
    if (reload) {
      await _load(openNowOnly: filter == WorkshopFilter.bukaSekarang);
    }
  }

  void setSearchQuery(String query) =>
      state = state.copyWith(searchQuery: query);

  void previewWorkshop(String workshopId) =>
      state = state.copyWith(previewedWorkshopId: workshopId);

  Workshop? previewedWorkshop(String? chosenWorkshopId) {
    final visible = visibleWorkshops;
    if (visible.isEmpty) return null;
    for (final id in [state.previewedWorkshopId, chosenWorkshopId]) {
      if (id == null) continue;
      for (final workshop in visible) {
        if (workshop.id == id) return workshop;
      }
    }
    return visible.first;
  }

  Future<void> _load({required bool openNowOnly}) async {
    final workshopRepo = ref.read(workshopRepositoryProvider);
    final catalogRepo = ref.read(catalogRepositoryProvider);

    final workshopsResult = await workshopRepo.getWorkshops(
      openNowOnly: openNowOnly,
    );
    if (!ref.mounted) return;
    if (workshopsResult is Error<List<Workshop>>) {
      state = state.copyWith(isLoading: false, hasError: true);
      return;
    }

    final servicesResult = await catalogRepo.getServiceTypes();
    if (!ref.mounted) return;
    if (servicesResult is Error<List<ServiceType>>) {
      state = state.copyWith(isLoading: false, hasError: true);
      return;
    }

    state = state.copyWith(
      isLoading: false,
      hasError: false,
      workshops: (workshopsResult as Ok<List<Workshop>>).value,
      serviceTypes: (servicesResult as Ok<List<ServiceType>>).value,
    );
  }

  List<Workshop> get visibleWorkshops {
    final query = state.searchQuery.trim().toLowerCase();
    final filtered = query.isEmpty
        ? state.workshops
        : state.workshops
              .where((w) => w.name.toLowerCase().contains(query))
              .toList();
    if (state.filter == WorkshopFilter.ratingTertinggi) {
      return [...filtered]..sort((a, b) => b.rating.compareTo(a.rating));
    }
    return filtered;
  }

  String statusLineFor(Workshop workshop) =>
      workshopStatusLine(workshop, ref.read(clockProvider).now());

  int? estimateMinFor(Workshop workshop, BookingDraft? draft) {
    if (draft == null || draft.selectedMotorIds.isEmpty) return null;
    final unitDurationsMin = [
      for (final motorId in draft.selectedMotorIds)
        _duration.unitDurationMin(
          selectedServiceTypesFor(
            draft.unitConfigs[motorId] ?? emptyUnitConfig(),
            state.serviceTypes,
          ),
        ),
    ];
    return _duration.sharedMakespanMin(
      unitDurationsMin: unitDurationsMin,
      bayCount: workshop.bayCount,
    );
  }
}
