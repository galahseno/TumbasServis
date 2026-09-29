import 'package:flutter/material.dart';
import 'package:tumbas_servis/booking/presentation/tiket/components/ticket_unit_row.dart';
import 'package:tumbas_servis/booking/presentation/utils/tiket_display.dart';
import 'package:tumbas_servis/core/presentation/components/skeleton.dart';
import 'package:tumbas_servis/core/presentation/theme/ts_theme_extension.dart';

class TicketUnitsPanel extends StatelessWidget {
  const TicketUnitsPanel({required this.lines, super.key});

  final List<TicketUnitLine>? lines;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final ext = TsThemeExtension.of(context);
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ext.borderDefault),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Status tiap motor',
            style: textTheme.titleSmall?.copyWith(color: scheme.onSurface),
          ),
          const SizedBox(height: 4),
          if (lines == null) ...const [
            SizedBox(height: 8),
            SkeletonBlock(height: 44),
            SizedBox(height: 8),
            SkeletonBlock(height: 44),
            SizedBox(height: 8),
            SkeletonBlock(height: 44),
          ] else
            for (final line in lines!) TicketUnitRow(line: line),
          const SizedBox(height: 4),
          Text(
            'Status berubah setelah motor check-in di bengkel.',
            style: textTheme.bodySmall?.copyWith(color: ext.textMuted),
          ),
        ],
      ),
    );
  }
}
