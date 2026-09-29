import 'package:flutter/material.dart';
import 'package:tumbas_servis/core/presentation/theme/ts_theme_extension.dart';

class PriceLine extends StatelessWidget {
  const PriceLine({
    required this.label,
    required this.value,
    this.emphasized = false,
    super.key,
  });

  final String label;
  final String value;
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    final ext = TsThemeExtension.of(context);
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final style = (emphasized ? textTheme.titleSmall : textTheme.bodyMedium)
        ?.copyWith(
          color: emphasized ? scheme.onSurface : ext.textBody,
          fontFeatures: const [FontFeature.tabularFigures()],
        );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: style?.copyWith(fontFeatures: null),
            ),
          ),
          Text(value, style: style),
        ],
      ),
    );
  }
}
