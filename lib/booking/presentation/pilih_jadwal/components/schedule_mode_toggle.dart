import 'package:flutter/material.dart';
import 'package:tumbas_servis/core/presentation/components/ts_switch.dart';
import 'package:tumbas_servis/core/presentation/theme/ts_theme_extension.dart';

class ScheduleModeToggle extends StatelessWidget {
  const ScheduleModeToggle({
    required this.splitMode,
    required this.onChanged,
    super.key,
  });

  final bool splitMode;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final ext = TsThemeExtension.of(context);
    final textTheme = Theme.of(context).textTheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onChanged(!splitMode),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Pisah jadwal per motor',
                      style: textTheme.labelLarge?.copyWith(
                        color: scheme.onSurface,
                      ),
                    ),
                    Text(
                      splitMode
                          ? 'Atur jam datang untuk tiap motor.'
                          : 'Semua motor datang di jam yang sama.',
                      style: textTheme.bodySmall?.copyWith(
                        color: ext.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              TsSwitch(
                value: splitMode,
                onChanged: onChanged,
                semanticLabel:
                    'Pisah jadwal per motor, '
                    '${splitMode ? 'aktif' : 'nonaktif'}',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
