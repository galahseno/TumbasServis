import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tumbas_servis/app/navigation/router.dart';
import 'package:tumbas_servis/app/navigation/routes.dart';
import 'package:tumbas_servis/auth/data/di/auth_data_module.dart';
import 'package:tumbas_servis/core/domain/model/result.dart';
import 'package:tumbas_servis/core/domain/repository/settings/app_theme_mode.dart';
import 'package:tumbas_servis/profile/data/di/profile_data_module.dart';

final themeModeProvider = NotifierProvider<ThemeModeNotifier, AppThemeMode>(
  ThemeModeNotifier.new,
);

class ThemeModeNotifier extends Notifier<AppThemeMode> {
  @override
  AppThemeMode build() {
    _load();
    return AppThemeMode.system;
  }

  Future<void> _load() async {
    final result = await ref.read(settingsRepositoryProvider).getThemeMode();
    state = switch (result) {
      Ok(value: final mode) => mode,
      Error() => AppThemeMode.system,
    };
  }

  Future<void> setThemeMode(AppThemeMode mode) async {
    state = mode;
    await ref.read(settingsRepositoryProvider).setThemeMode(mode);
  }
}

final logoutHandlerProvider = Provider<LogoutHandler>(
  (ref) => LogoutHandler(ref),
);

class LogoutHandler {
  LogoutHandler(this._ref);

  final Ref _ref;

  Future<void> call() async {
    final result = await _ref.read(sessionRepositoryProvider).logout();
    switch (result) {
      case Ok():
        _ref.read(routerProvider).go(Routes.login);
      case Error():
        break;
    }
  }
}
