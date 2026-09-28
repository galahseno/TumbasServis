import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tumbas_servis/auth/data/repository/session_repository_impl.dart';
import 'package:tumbas_servis/core/data/di/core_data_module.dart';
import 'package:tumbas_servis/core/domain/repository/session/session_repository.dart';

final sessionRepositoryProvider = Provider<SessionRepository>((ref) {
  return SessionRepositoryImpl(
    localStore: ref.watch(localStoreProvider),
    mockJsonLoader: ref.watch(mockJsonLoaderProvider),
    latencySimulator: ref.watch(latencySimulatorProvider),
    demoModeController: ref.watch(demoModeControllerProvider),
  );
});
