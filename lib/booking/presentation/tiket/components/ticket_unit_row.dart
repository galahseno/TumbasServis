import 'package:flutter/material.dart';
import 'package:tumbas_servis/booking/presentation/utils/tiket_display.dart';
import 'package:tumbas_servis/core/presentation/components/unit_status_badge.dart';
import 'package:tumbas_servis/core/presentation/theme/ts_theme_extension.dart';

class TicketUnitRow extends StatelessWidget {
  const TicketUnitRow({required this.line, super.key});

  final TicketUnitLine line;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final ext = TsThemeExtension.of(context);
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  line.motorName,
                  style: textTheme.titleSmall?.copyWith(
                    color: scheme.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  line.summary,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.bodySmall?.copyWith(color: ext.textMuted),
                ),
                if (line.slotLine != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    line.slotLine!,
                    style: textTheme.bodySmall?.copyWith(color: ext.textMuted),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 12),
          UnitStatusBadge(
            status: line.status,
            size: UnitStatusBadgeSize.compact,
          ),
        ],
      ),
    );
  }
}
