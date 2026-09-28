import 'package:flutter/material.dart';
import 'package:tumbas_servis/core/domain/model/workshop/workshop.dart';
import 'package:tumbas_servis/core/presentation/theme/ts_theme_extension.dart';
import 'package:tumbas_servis/workshop/presentation/components/chosen_tag.dart';
import 'package:tumbas_servis/workshop/presentation/components/workshop_status_pill.dart';
import 'package:tumbas_servis/workshop/presentation/utils/workshop_status_display.dart';

class WorkshopCard extends StatelessWidget {
  const WorkshopCard({
    required this.workshop,
    required this.statusLine,
    required this.open,
    required this.chosen,
    required this.onTap,
    super.key,
    this.estimateLabel,
  });

  final Workshop workshop;
  final String statusLine;
  final bool open;
  final bool chosen;
  final String? estimateLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final ext = TsThemeExtension.of(context);
    final textTheme = Theme.of(context).textTheme;

    final bayLine = estimateLabel == null
        ? '${workshop.bayCount} bay servis'
        : '${workshop.bayCount} bay servis · $estimateLabel';

    return Semantics(
      button: true,
      label:
          '${workshop.name}, ${workshopRatingLabel(workshop.rating)}, '
          '$statusLine${chosen ? ', dipilih' : ''}',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: scheme.surfaceContainer,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: chosen ? ext.borderAccent : ext.borderDefault,
                width: chosen ? 2 : 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        workshop.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.titleMedium?.copyWith(
                          color: scheme.onSurface,
                        ),
                      ),
                    ),
                    if (chosen) ...[
                      const SizedBox(width: 8),
                      const ChosenTag(),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.star_rounded, size: 16, color: ext.ratingStar),
                    const SizedBox(width: 4),
                    Text(
                      workshopRatingLabel(workshop.rating),
                      style: textTheme.bodySmall?.copyWith(color: ext.textBody),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '· ${workshopDistanceLabel(workshop.distanceKm)}',
                      style: textTheme.bodySmall?.copyWith(
                        color: ext.textMuted,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                WorkshopStatusPill(open: open, label: statusLine),
                const SizedBox(height: 4),
                Text(
                  bayLine,
                  style: textTheme.bodySmall?.copyWith(color: ext.textBody),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
