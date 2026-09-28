import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tumbas_servis/core/data/di/core_data_module.dart';
import 'package:tumbas_servis/core/domain/repository/workshop/workshop_repository.dart';
import 'package:tumbas_servis/workshop/data/repository/workshop_repository_impl.dart';

final workshopRepositoryProvider = Provider<WorkshopRepository>((ref) {
  return WorkshopRepositoryImpl(
    mockJsonLoader: ref.watch(mockJsonLoaderProvider),
    latencySimulator: ref.watch(latencySimulatorProvider),
    clock: ref.watch(clockProvider),
    localStore: ref.watch(localStoreProvider),
  );
});
