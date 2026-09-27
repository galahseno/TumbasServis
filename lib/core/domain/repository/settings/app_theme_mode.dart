enum AppThemeMode { system, light, dark, unknown }

extension AppThemeModeX on AppThemeMode {
  static AppThemeMode fromString(String? value) => switch (value) {
    'system' => AppThemeMode.system,
    'light' => AppThemeMode.light,
    'dark' => AppThemeMode.dark,
    _ => AppThemeMode.unknown,
  };
}
