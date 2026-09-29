import 'package:flutter/material.dart';
import 'package:tumbas_servis/core/presentation/theme/ts_theme_extension.dart';
import 'package:tumbas_servis/review/presentation/ulasan/components/rating_stars.dart';

class MechanicRatingRow extends StatelessWidget {
  const MechanicRatingRow({
    required this.name,
    required this.initial,
    required this.unitsLabel,
    required this.value,
    required this.onChanged,
    super.key,
  });

  final String name;
  final String initial;
  final String unitsLabel;
  final int value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final ext = TsThemeExtension.of(context);
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: ext.accent.withValues(alpha: 0.12),
                child: Text(
                  initial,
                  style: textTheme.titleSmall?.copyWith(color: ext.textAccent),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: textTheme.titleSmall?.copyWith(
                        color: scheme.onSurface,
                      ),
                    ),
                    Text(
                      unitsLabel,
                      style: textTheme.bodySmall?.copyWith(
                        color: ext.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Opsional',
                style: textTheme.labelSmall?.copyWith(color: ext.textMuted),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Align(
            alignment: Alignment.centerLeft,
            child: RatingStars.input(
              value: value,
              onChanged: onChanged,
              semanticLabel: 'Nilai $name',
              size: RatingStarsSize.compact,
            ),
          ),
          if (value > 0)
            Padding(
              padding: const EdgeInsets.only(left: 4),
              child: RatingLabel(value: value),
            ),
        ],
      ),
    );
  }
}
