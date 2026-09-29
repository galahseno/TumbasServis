import 'package:flutter/material.dart';
import 'package:tumbas_servis/core/domain/model/booking/unit_status.dart';
import 'package:tumbas_servis/core/presentation/components/unit_status_badge.dart';
import 'package:tumbas_servis/core/presentation/theme/ts_theme_extension.dart';
import 'package:tumbas_servis/core/presentation/utils/currency_formatter.dart';
import 'package:tumbas_servis/core/presentation/utils/date_formatter.dart';
import 'package:tumbas_servis/core/presentation/utils/time_formatter.dart';
import 'package:tumbas_servis/garage/presentation/motor_detail/state/motor_detail_state.dart';

class ServiceHistoryRow extends StatelessWidget {
  const ServiceHistoryRow({
    required this.entry,
    required this.onTap,
    super.key,
  });

  final MotorHistoryEntry entry;
  final VoidCallback onTap;

  static String _statusLabel(UnitStatus status) => switch (status) {
    UnitStatus.selesai => 'Selesai',
    UnitStatus.dibatalkan => 'Dibatalkan',
    UnitStatus.terjadwal || UnitStatus.unknown => 'Terjadwal',
    UnitStatus.checkIn => 'Check-in',
    UnitStatus.diperiksa => 'Diperiksa',
    UnitStatus.dikerjakan => 'Dikerjakan',
    UnitStatus.qc => 'QC',
  };

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final ext = TsThemeExtension.of(context);
    final textTheme = Theme.of(context).textTheme;

    final isActive = !entry.status.isTerminal;
    final isCancelled = entry.status == UnitStatus.dibatalkan;
    final date = isActive
        ? '${DateFormatter.format(entry.dateTime)} · '
              '${TimeFormatter.format(entry.dateTime)}'
        : DateFormatter.format(entry.dateTime);
    final textColor = isCancelled ? ext.textMuted : scheme.onSurface;
    final summary = [
      if (entry.servicesSummary.isNotEmpty) entry.servicesSummary,
      if (entry.status == UnitStatus.selesai)
        CurrencyFormatter.format(entry.subtotal),
    ].join(' · ');

    return Semantics(
      button: true,
      label: '${entry.code}, ${_statusLabel(entry.status)}, $date',
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
              color: isActive ? ext.borderAccent : ext.borderDefault,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.code,
                      style: textTheme.titleSmall?.copyWith(color: textColor),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            date,
                            style: textTheme.bodySmall?.copyWith(
                              color: ext.textMuted,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        UnitStatusBadge(
                          status: entry.status,
                          size: UnitStatusBadgeSize.compact,
                        ),
                      ],
                    ),
                    if (summary.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        summary,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.bodyMedium?.copyWith(color: textColor),
                      ),
                    ],
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
