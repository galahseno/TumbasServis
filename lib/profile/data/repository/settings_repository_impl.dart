// ignore_for_file: prefer_initializing_formals
import 'package:tumbas_servis/core/data/service/local_store.dart';
import 'package:tumbas_servis/core/domain/model/result.dart';
import 'package:tumbas_servis/core/domain/repository/settings/app_theme_mode.dart';
import 'package:tumbas_servis/core/domain/repository/settings/settings_repository.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  SettingsRepositoryImpl({required LocalStore localStore})
    : _localStore = localStore;

  final LocalStore _localStore;

  @override
  Future<Result<AppThemeMode>> getThemeMode() async {
    try {
      return Result.ok(_localStore.getThemeMode());
    } catch (e) {
      return Result.error(e is Exception ? e : Exception(e.toString()));
    }
  }

  @override
  Future<Result<void>> setThemeMode(AppThemeMode mode) async {
    try {
      await _localStore.setThemeMode(mode);
      return const Result.ok(null);
    } catch (e) {
      return Result.error(e is Exception ? e : Exception(e.toString()));
    }
  }

  @override
  Future<Result<bool>> isDemoModeEnabled() async {
    try {
      return Result.ok(_localStore.getDemoModeEnabled());
    } catch (e) {
      return Result.error(e is Exception ? e : Exception(e.toString()));
    }
  }

  @override
  Future<Result<void>> setDemoMode(bool enabled) async {
    try {
      await _localStore.setDemoModeEnabled(enabled);
      return const Result.ok(null);
    } catch (e) {
      return Result.error(e is Exception ? e : Exception(e.toString()));
    }
  }
}
