import 'package:flutter/material.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking_unit.dart';
import 'package:tumbas_servis/core/presentation/components/unit_status_badge.dart';
import 'package:tumbas_servis/core/presentation/theme/ts_theme_extension.dart';
import 'package:tumbas_servis/tracking/presentation/lacak_unit/components/status_timeline.dart';

class DemoPreviewPane extends StatelessWidget {
  const DemoPreviewPane({required this.unit, required this.now, super.key});

  final BookingUnit? unit;
  final DateTime now;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final ext = TsThemeExtension.of(context);
    final textTheme = Theme.of(context).textTheme;
    final unit = this.unit;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ext.borderDefault),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Pratinjau status',
            style: textTheme.titleSmall?.copyWith(color: scheme.onSurface),
          ),
          const SizedBox(height: 12),
          if (unit == null)
            Text(
              'Pilih booking berlangsung untuk melihat pratinjau.',
              style: textTheme.bodyMedium?.copyWith(color: ext.textMuted),
            )
          else ...[
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Unit ${unit.unitCode} · ${unit.motorSnapshot.nickname}',
                    style: textTheme.titleSmall?.copyWith(
                      color: scheme.onSurface,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                UnitStatusBadge(
                  status: unit.status,
                  size: UnitStatusBadgeSize.compact,
                ),
              ],
            ),
            const SizedBox(height: 16),
            StatusTimeline(unit: unit, now: now),
          ],
        ],
      ),
    );
  }
}
