import 'package:flutter/material.dart';
import 'package:tumbas_servis/core/presentation/theme/ts_theme_extension.dart';

class SectionTitleRow extends StatelessWidget {
  const SectionTitleRow({
    required this.title,
    super.key,
    this.onSeeAll,
    this.seeAllSemanticLabel,
  });

  final String title;
  final VoidCallback? onSeeAll;
  final String? seeAllSemanticLabel;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final ext = TsThemeExtension.of(context);
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: textTheme.titleMedium?.copyWith(color: scheme.onSurface),
          ),
        ),
        if (onSeeAll != null)
          Semantics(
            button: true,
            label: seeAllSemanticLabel ?? 'Lihat semua',
            excludeSemantics: true,
            child: InkWell(
              onTap: onSeeAll,
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 4,
                  vertical: 12,
                ),
                child: Text(
                  'Lihat semua',
                  style: textTheme.labelLarge?.copyWith(color: ext.textAccent),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
