import 'package:tumbas_servis/core/domain/model/result.dart';
import 'package:tumbas_servis/core/domain/repository/settings/app_theme_mode.dart';
import 'package:tumbas_servis/core/domain/repository/settings/settings_repository.dart';

class FakeSettingsRepository implements SettingsRepository {
  AppThemeMode themeMode = AppThemeMode.system;
  bool demoModeEnabled = false;

  @override
  Future<Result<AppThemeMode>> getThemeMode() async => Result.ok(themeMode);

  @override
  Future<Result<void>> setThemeMode(AppThemeMode mode) async {
    themeMode = mode;
    return const Result.ok(null);
  }

  @override
  Future<Result<bool>> isDemoModeEnabled() async => Result.ok(demoModeEnabled);

  @override
  Future<Result<void>> setDemoMode(bool enabled) async {
    demoModeEnabled = enabled;
    return const Result.ok(null);
  }
}
