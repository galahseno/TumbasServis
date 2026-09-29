import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tumbas_servis/app/app_theme.dart';
import 'package:tumbas_servis/app/navigation/router.dart';
import 'package:tumbas_servis/core/domain/repository/settings/app_theme_mode.dart';
import 'package:tumbas_servis/core/presentation/di/core_presentation_module.dart';

extension on AppThemeMode {
  ThemeMode get toMaterialThemeMode => switch (this) {
    AppThemeMode.light => ThemeMode.light,
    AppThemeMode.dark => ThemeMode.dark,
    AppThemeMode.system || AppThemeMode.unknown => ThemeMode.system,
  };
}

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appThemeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: 'Tumbas Service',
      debugShowCheckedModeBanner: false,
      routerConfig: ref.watch(routerProvider),
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: appThemeMode.toMaterialThemeMode,
      themeAnimationDuration: Duration.zero,
    );
  }
}
