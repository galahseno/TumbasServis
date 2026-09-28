import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tumbas_servis/core/data/di/core_data_module.dart';
import 'package:tumbas_servis/core/domain/repository/settings/settings_repository.dart';
import 'package:tumbas_servis/profile/data/repository/settings_repository_impl.dart';

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  return SettingsRepositoryImpl(localStore: ref.watch(localStoreProvider));
});
