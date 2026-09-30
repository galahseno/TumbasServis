import 'package:flutter/material.dart';
import 'package:tumbas_servis/app/app_theme.dart';
import 'package:tumbas_servis/core/domain/repository/settings/app_theme_mode.dart';
import 'package:tumbas_servis/core/presentation/theme/ts_theme_extension.dart';

class ThemePreview extends StatelessWidget {
  const ThemePreview({required this.mode, super.key});

  final AppThemeMode mode;

  ThemeData _previewTheme(BuildContext context) {
    switch (mode) {
      case AppThemeMode.light:
        return AppTheme.light;
      case AppThemeMode.dark:
        return AppTheme.dark;
      case AppThemeMode.system:
      case AppThemeMode.unknown:
        return MediaQuery.platformBrightnessOf(context) == Brightness.dark
            ? AppTheme.dark
            : AppTheme.light;
    }
  }

  String get _caption => switch (mode) {
    AppThemeMode.light => 'Selalu terang.',
    AppThemeMode.dark => 'Selalu gelap.',
    _ => 'Mengikuti pengaturan perangkat.',
  };

  String get _chipLabel => switch (mode) {
    AppThemeMode.light => 'Terang',
    AppThemeMode.dark => 'Gelap',
    _ => 'Sistem',
  };

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final ext = TsThemeExtension.of(context);
    final textTheme = Theme.of(context).textTheme;

    return Semantics(
      container: true,
      label: 'Pratinjau tema $_chipLabel. $_caption',
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: scheme.surfaceContainer,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: ext.borderDefault),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Pratinjau tema',
                    style: textTheme.titleSmall?.copyWith(
                      color: scheme.onSurface,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: scheme.primaryContainer,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    _chipLabel,
                    style: textTheme.labelMedium?.copyWith(
                      color: scheme.onPrimaryContainer,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ExcludeSemantics(
              child: Theme(
                data: _previewTheme(context),
                child: const _MiniApp(),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              _caption,
              style: textTheme.bodySmall?.copyWith(color: ext.textMuted),
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniApp extends StatelessWidget {
  const _MiniApp();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final ext = TsThemeExtension.of(context);

    Widget card() => Container(
      height: 72,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: scheme.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ext.borderDefault),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: scheme.primaryContainer,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 10,
                  decoration: BoxDecoration(
                    color: scheme.onSurface.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 8),
                FractionallySizedBox(
                  widthFactor: 0.6,
                  child: Container(
                    height: 8,
                    decoration: BoxDecoration(
                      color: ext.textMuted.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: ColoredBox(
        color: scheme.surface,
        child: Column(
          children: [
            Container(height: 48, color: scheme.primary),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [card(), const SizedBox(height: 8), card()],
              ),
            ),
            Container(
              height: 44,
              decoration: BoxDecoration(
                color: scheme.surface,
                border: Border(top: BorderSide(color: ext.borderDefault)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  for (var i = 0; i < 4; i++)
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: i == 0 ? scheme.primary : ext.textFaint,
                        shape: BoxShape.circle,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
