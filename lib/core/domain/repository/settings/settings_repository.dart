import 'package:tumbas_servis/core/domain/model/result.dart';
import 'package:tumbas_servis/core/domain/repository/settings/app_theme_mode.dart';

abstract class SettingsRepository {
  Future<Result<AppThemeMode>> getThemeMode();
  Future<Result<void>> setThemeMode(AppThemeMode mode);
  Future<Result<bool>> isDemoModeEnabled();
  Future<Result<void>> setDemoMode(bool enabled);
}
