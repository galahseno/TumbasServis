import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tumbas_servis/catalog/data/di/catalog_data_module.dart';
import 'package:tumbas_servis/core/data/di/core_data_module.dart';
import 'package:tumbas_servis/core/domain/model/catalog/service_type.dart';
import 'package:tumbas_servis/core/domain/model/result.dart';
import 'package:tumbas_servis/core/domain/model/workshop/workshop.dart';
import 'package:tumbas_servis/workshop/data/di/workshop_data_module.dart';
import 'package:tumbas_servis/workshop/presentation/detail_bengkel/state/detail_bengkel_state.dart';
import 'package:tumbas_servis/workshop/presentation/utils/workshop_status_display.dart';

class DetailBengkelViewModel extends Notifier<DetailBengkelState> {
  String? _workshopId;

  @override
  DetailBengkelState build() => const DetailBengkelState();

  Future<void> initialize(String workshopId) async {
    if (_workshopId == workshopId) return;
    _workshopId = workshopId;
    state = const DetailBengkelState();
    await _load(workshopId);
  }

  Future<void> retry() async {
    final id = _workshopId;
    if (id == null) return;
    state = state.copyWith(isLoading: true, hasError: false);
    await _load(id);
  }

  Future<void> _load(String workshopId) async {
    final workshopRepo = ref.read(workshopRepositoryProvider);
    final catalogRepo = ref.read(catalogRepositoryProvider);

    final workshopResult = await workshopRepo.getWorkshop(workshopId);
    if (!ref.mounted) return;
    if (workshopResult is Error<Workshop>) {
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
      workshop: (workshopResult as Ok<Workshop>).value,
      serviceTypes: (servicesResult as Ok<List<ServiceType>>).value,
    );
  }

  bool isOpenNow(Workshop workshop) =>
      isWorkshopOpenNow(workshop, ref.read(clockProvider).now());

  String statusLineFor(Workshop workshop) =>
      workshopStatusLine(workshop, ref.read(clockProvider).now());

  List<String> serviceNamesFor(Workshop workshop) {
    final nameById = {for (final s in state.serviceTypes) s.id: s.name};
    return [
      for (final id in workshop.serviceIds)
        if (nameById[id] != null) nameById[id]!,
    ];
  }
}
