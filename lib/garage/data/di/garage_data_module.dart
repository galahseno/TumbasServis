import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tumbas_servis/core/data/di/core_data_module.dart';
import 'package:tumbas_servis/core/domain/repository/garage/garage_repository.dart';
import 'package:tumbas_servis/garage/data/repository/garage_repository_impl.dart';

final garageRepositoryProvider = Provider<GarageRepository>((ref) {
  return GarageRepositoryImpl(
    localStore: ref.watch(localStoreProvider),
    mockJsonLoader: ref.watch(mockJsonLoaderProvider),
    latencySimulator: ref.watch(latencySimulatorProvider),
    hasActiveBooking: (_) async => false,
  );
});
