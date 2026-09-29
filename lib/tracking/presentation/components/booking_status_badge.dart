import 'package:flutter/material.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking_status.dart';
import 'package:tumbas_servis/core/presentation/theme/ts_theme_extension.dart';
import 'package:tumbas_servis/tracking/presentation/utils/tracking_display.dart';

class BookingStatusBadge extends StatelessWidget {
  const BookingStatusBadge({required this.status, super.key});

  final BookingStatus status;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final ext = TsThemeExtension.of(context);

    final (IconData icon, Color soft, Color text) = switch (status) {
      BookingStatus.terjadwal || BookingStatus.unknown => (
        Icons.schedule_rounded,
        scheme.surfaceContainerLow,
        ext.textMuted,
      ),
      BookingStatus.berlangsung => (
        Icons.build_rounded,
        scheme.primaryContainer,
        scheme.onPrimaryContainer,
      ),
      BookingStatus.selesai => (
        Icons.check_circle_rounded,
        ext.successSoft,
        ext.successText,
      ),
      BookingStatus.dibatalkan => (
        Icons.cancel_rounded,
        ext.dangerSoft,
        ext.dangerText,
      ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: soft,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: text),
          const SizedBox(width: 4),
          Text(
            status.label,
            style: Theme.of(
              context,
            ).textTheme.labelSmall?.copyWith(color: text),
          ),
        ],
      ),
    );
  }
}
