import 'package:flutter/material.dart';
import 'package:tumbas_servis/core/presentation/theme/ts_theme_extension.dart';

class WorkshopSummaryRow extends StatelessWidget {
  const WorkshopSummaryRow({
    required this.workshopName,
    required this.bayCount,
    required this.onUbah,
    super.key,
  });

  final String workshopName;
  final int bayCount;
  final VoidCallback onUbah;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final ext = TsThemeExtension.of(context);
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: scheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: Icon(
              Icons.storefront_rounded,
              size: 20,
              color: ext.textBody,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              '$workshopName · $bayCount bay servis',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: textTheme.bodyMedium?.copyWith(color: scheme.onSurface),
            ),
          ),
          SizedBox(
            height: 48,
            child: Center(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onUbah,
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      'Ubah',
                      style: textTheme.labelLarge?.copyWith(
                        color: ext.textAccent,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
