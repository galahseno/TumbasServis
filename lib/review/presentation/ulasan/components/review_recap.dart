import 'package:flutter/material.dart';
import 'package:tumbas_servis/core/domain/model/review/review.dart';
import 'package:tumbas_servis/core/presentation/theme/ts_theme_extension.dart';
import 'package:tumbas_servis/core/presentation/utils/date_formatter.dart';
import 'package:tumbas_servis/core/presentation/utils/time_formatter.dart';
import 'package:tumbas_servis/review/presentation/ulasan/components/rating_stars.dart';
import 'package:tumbas_servis/review/presentation/ulasan/state/ulasan_state.dart';

class ReviewRecap extends StatelessWidget {
  const ReviewRecap({
    required this.review,
    required this.workshopName,
    required this.mechanics,
    super.key,
    this.preview = false,
  });

  final Review review;
  final String workshopName;
  final List<MechanicRatingItem> mechanics;

  final bool preview;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final ext = TsThemeExtension.of(context);
    final textTheme = Theme.of(context).textTheme;
    final comment = review.workshopComment?.trim() ?? '';
    if (preview && review.workshopRating == 0) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: scheme.surfaceContainer,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(Icons.rate_review_outlined, color: ext.textFaint, size: 32),
            const SizedBox(height: 8),
            Text(
              'Ulasanmu akan tampil di sini',
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium?.copyWith(color: ext.textMuted),
            ),
          ],
        ),
      );
    }
    final rated = [
      for (final m in mechanics)
        if (review.mechanicRatings.containsKey(m.mechanicId)) m,
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            workshopName,
            style: textTheme.titleSmall?.copyWith(color: scheme.onSurface),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              RatingStars.display(
                value: review.workshopRating.toDouble(),
                semanticLabel: 'Nilai bengkel',
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  '${ratingWord(review.workshopRating)} · '
                  '${review.workshopRating} dari 5',
                  style: textTheme.bodyMedium?.copyWith(color: ext.textBody),
                ),
              ),
            ],
          ),
          if (comment.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              comment,
              style: textTheme.bodyMedium?.copyWith(color: scheme.onSurface),
            ),
          ],
          if (rated.isNotEmpty) ...[
            const SizedBox(height: 12),
            Divider(height: 1, color: ext.borderDefault),
            const SizedBox(height: 8),
            for (final m in rated)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            m.name,
                            style: textTheme.labelLarge?.copyWith(
                              color: scheme.onSurface,
                            ),
                          ),
                          Text(
                            m.unitsLabel,
                            style: textTheme.bodySmall?.copyWith(
                              color: ext.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    RatingStars.display(
                      value: review.mechanicRatings[m.mechanicId]!.toDouble(),
                      semanticLabel: 'Nilai ${m.name}',
                    ),
                  ],
                ),
              ),
          ],
          const SizedBox(height: 12),
          Text(
            preview
                ? 'Pratinjau ulasanmu'
                : 'Dikirim ${DateFormatter.format(review.createdAt)} · '
                      '${TimeFormatter.format(review.createdAt)}',
            style: textTheme.bodySmall?.copyWith(
              color: ext.textMuted,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
  }
}
