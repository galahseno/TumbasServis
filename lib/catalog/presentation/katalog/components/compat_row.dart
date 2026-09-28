import 'package:flutter/material.dart';
import 'package:tumbas_servis/core/presentation/theme/ts_theme_extension.dart';

class CompatRow extends StatelessWidget {
  const CompatRow({required this.label, required this.compatible, super.key});

  final String label;
  final bool compatible;

  @override
  Widget build(BuildContext context) {
    final ext = TsThemeExtension.of(context);
    final textTheme = Theme.of(context).textTheme;
    final color = compatible ? ext.success : ext.textMuted;
    final icon = compatible ? Icons.check_circle_rounded : Icons.cancel_rounded;
    final statusText = compatible ? 'Cocok' : 'Tidak cocok';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: textTheme.bodyMedium?.copyWith(color: ext.textBody),
            ),
          ),
          Text(
            statusText,
            style: textTheme.labelMedium?.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}
