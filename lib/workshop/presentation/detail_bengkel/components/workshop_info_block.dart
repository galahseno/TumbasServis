import 'package:flutter/material.dart';
import 'package:tumbas_servis/core/domain/model/workshop/workshop.dart';
import 'package:tumbas_servis/core/presentation/theme/ts_theme_extension.dart';
import 'package:tumbas_servis/workshop/presentation/components/chosen_tag.dart';
import 'package:tumbas_servis/workshop/presentation/components/workshop_status_pill.dart';
import 'package:tumbas_servis/workshop/presentation/utils/workshop_status_display.dart';

class WorkshopInfoBlock extends StatelessWidget {
  const WorkshopInfoBlock({
    required this.workshop,
    required this.statusLine,
    required this.open,
    required this.chosen,
    super.key,
  });

  final Workshop workshop;
  final String statusLine;
  final bool open;
  final bool chosen;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final ext = TsThemeExtension.of(context);
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                workshop.name,
                style: textTheme.headlineSmall?.copyWith(
                  color: scheme.onSurface,
                ),
              ),
            ),
            if (chosen) ...[const SizedBox(width: 8), const ChosenTag()],
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Icon(Icons.star_rounded, size: 16, color: ext.ratingStar),
            const SizedBox(width: 4),
            Text(
              '${workshopRatingLabel(workshop.rating)} '
              '(${workshop.reviewCount} ulasan)',
              style: textTheme.bodyMedium?.copyWith(color: ext.textBody),
            ),
          ],
        ),
        const SizedBox(height: 8),
        WorkshopStatusPill(open: open, label: statusLine),
        const SizedBox(height: 4),
        Text(
          workshopHoursLine(workshop),
          style: textTheme.bodyMedium?.copyWith(color: ext.textMuted),
        ),
        Text(
          '${workshop.bayCount} bay servis',
          style: textTheme.bodyMedium?.copyWith(color: ext.textMuted),
        ),
      ],
    );
  }
}
