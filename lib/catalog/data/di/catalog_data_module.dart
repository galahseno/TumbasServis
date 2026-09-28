import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tumbas_servis/catalog/data/repository/catalog_repository_impl.dart';
import 'package:tumbas_servis/core/data/di/core_data_module.dart';
import 'package:tumbas_servis/core/domain/repository/catalog/catalog_repository.dart';

final catalogRepositoryProvider = Provider<CatalogRepository>((ref) {
  return CatalogRepositoryImpl(
    mockJsonLoader: ref.watch(mockJsonLoaderProvider),
    latencySimulator: ref.watch(latencySimulatorProvider),
  );
});
