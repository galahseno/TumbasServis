import 'package:flutter/material.dart';
import 'package:tumbas_servis/core/domain/repository/settings/app_theme_mode.dart';
import 'package:tumbas_servis/core/presentation/components/ts_segmented_control.dart';
import 'package:tumbas_servis/core/presentation/theme/ts_theme_extension.dart';

class ThemeSetting extends StatelessWidget {
  const ThemeSetting({required this.mode, required this.onChanged, super.key});

  final AppThemeMode mode;
  final ValueChanged<AppThemeMode> onChanged;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final ext = TsThemeExtension.of(context);
    final textTheme = Theme.of(context).textTheme;
    final selected = mode == AppThemeMode.unknown ? AppThemeMode.system : mode;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.palette_outlined, size: 24, color: ext.textBody),
              const SizedBox(width: 16),
              Text(
                'Tema',
                style: textTheme.titleSmall?.copyWith(color: scheme.onSurface),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TsSegmentedControl<AppThemeMode>(
            semanticLabel: 'Tema',
            selected: selected,
            onChanged: onChanged,
            segments: const [
              TsSegment(
                value: AppThemeMode.system,
                label: 'Sistem',
                icon: Icons.brightness_auto_outlined,
              ),
              TsSegment(
                value: AppThemeMode.light,
                label: 'Terang',
                icon: Icons.light_mode_outlined,
              ),
              TsSegment(
                value: AppThemeMode.dark,
                label: 'Gelap',
                icon: Icons.dark_mode_outlined,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
