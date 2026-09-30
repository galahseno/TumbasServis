import 'package:flutter/material.dart';
import 'package:tumbas_servis/core/presentation/theme/ts_theme_extension.dart';
import 'package:tumbas_servis/core/presentation/utils/date_formatter.dart';
import 'package:tumbas_servis/tracking/presentation/components/booking_status_badge.dart';
import 'package:tumbas_servis/tracking/presentation/riwayat/state/riwayat_state.dart';
import 'package:tumbas_servis/tracking/presentation/utils/tracking_display.dart';

class BookingHistoryCard extends StatelessWidget {
  const BookingHistoryCard({
    required this.entry,
    required this.onTap,
    super.key,
    this.selected = false,
  });

  final HistoryEntry entry;
  final VoidCallback onTap;

  final bool selected;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final ext = TsThemeExtension.of(context);
    final textTheme = Theme.of(context).textTheme;
    final booking = entry.booking;
    final unitCount = booking.units.length;
    final slot = bookingPrimarySlot(booking);
    final dateLabel = DateFormatter.format(slot?.date ?? booking.createdAt);

    return Semantics(
      button: true,
      selected: selected,
      label:
          '${booking.code}, ${booking.status.label}, ${entry.workshopName}, '
          '$dateLabel, $unitCount motor',
      excludeSemantics: true,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: scheme.surfaceContainer,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: selected ? ext.borderAccent : ext.borderDefault,
              width: selected ? 2 : 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      booking.code,
                      style: textTheme.titleMedium?.copyWith(
                        color: scheme.onSurface,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  BookingStatusBadge(status: booking.status),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    Icons.storefront_outlined,
                    size: 20,
                    color: ext.textBody,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      entry.workshopName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.bodyMedium?.copyWith(
                        color: ext.textBody,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '$dateLabel · $unitCount motor',
                      style: textTheme.bodySmall?.copyWith(
                        color: ext.textMuted,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.chevron_right_rounded,
                    size: 20,
                    color: ext.textMuted,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
