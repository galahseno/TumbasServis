import 'package:flutter/material.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking_unit.dart';
import 'package:tumbas_servis/core/presentation/components/unit_status_badge.dart';
import 'package:tumbas_servis/core/presentation/theme/ts_theme_extension.dart';
import 'package:tumbas_servis/tracking/presentation/utils/tracking_display.dart';

class UnitStatusRow extends StatelessWidget {
  const UnitStatusRow({
    required this.unit,
    required this.meta,
    required this.onTap,
    super.key,
    this.showDivider = true,
  });

  final BookingUnit unit;
  final String meta;
  final VoidCallback onTap;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final ext = TsThemeExtension.of(context);
    final textTheme = Theme.of(context).textTheme;
    final cancelled = unit.status.name == 'dibatalkan';

    return Semantics(
      button: true,
      label:
          '${unit.motorSnapshot.nickname}, unit ${unit.unitCode}, '
          '${unit.status.timelineLabel}',
      excludeSemantics: true,
      child: InkWell(
        onTap: onTap,
        child: Container(
          constraints: const BoxConstraints(minHeight: 66),
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            border: showDivider
                ? Border(bottom: BorderSide(color: ext.borderDefault))
                : null,
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 12,
                      runSpacing: 6,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          unit.motorSnapshot.nickname,
                          style: textTheme.titleMedium?.copyWith(
                            color: cancelled ? ext.textMuted : scheme.onSurface,
                          ),
                        ),
                        UnitStatusBadge(status: unit.status),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      meta,
                      style: textTheme.bodyMedium?.copyWith(
                        color: ext.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.chevron_right_rounded, color: ext.textMuted),
            ],
          ),
        ),
      ),
    );
  }
}
