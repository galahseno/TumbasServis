import 'package:flutter/material.dart';
import 'package:tumbas_servis/core/presentation/components/ts_button.dart';
import 'package:tumbas_servis/core/presentation/theme/ts_theme_extension.dart';

class DemoModeShortcut extends StatelessWidget {
  const DemoModeShortcut({
    required this.onAdvance,
    required this.onReset,
    super.key,
  });

  final VoidCallback? onAdvance;
  final VoidCallback? onReset;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final ext = TsThemeExtension.of(context);
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ext.borderDefault),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.bolt_rounded, size: 20, color: ext.textMuted),
              const SizedBox(width: 8),
              Text(
                'MODE DEMO',
                style: textTheme.labelMedium?.copyWith(
                  color: ext.textMuted,
                  letterSpacing: 0.6,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Kontrol status khusus demo — bukan bagian produk.',
            style: textTheme.bodyMedium?.copyWith(color: ext.textMuted),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              TsButton(
                label: 'Majukan status',
                type: TsButtonType.outline,
                compact: true,
                fullWidth: false,
                onPressed: onAdvance,
              ),
              TsButton(
                label: 'Reset',
                type: TsButtonType.ghost,
                compact: true,
                fullWidth: false,
                onPressed: onReset,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
