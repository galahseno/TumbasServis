import 'package:flutter/material.dart';
import 'package:tumbas_servis/core/presentation/theme/ts_theme_extension.dart';

class GarageAddTile extends StatelessWidget {
  const GarageAddTile({required this.onTap, this.width = 124, super.key});

  final VoidCallback onTap;
  final double width;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final ext = TsThemeExtension.of(context);
    final textTheme = Theme.of(context).textTheme;

    return Semantics(
      button: true,
      label: 'Tambah motor',
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: width,
          constraints: const BoxConstraints(minHeight: 48),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: scheme.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: ext.borderDefault),
          ),
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.add_circle_outline_rounded, color: ext.textAccent),
              const SizedBox(height: 8),
              Text(
                'Tambah motor',
                textAlign: TextAlign.center,
                style: textTheme.labelMedium?.copyWith(color: ext.textAccent),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
