import 'package:flutter/material.dart';
import 'package:tumbas_servis/core/domain/model/booking/unit_status.dart';
import 'package:tumbas_servis/core/presentation/theme/ts_theme_extension.dart';

enum UnitStatusBadgeSize { compact, regular }

class _StatusVisual {
  const _StatusVisual(this.label, this.icon, this.soft, this.text);

  final String label;
  final IconData icon;
  final Color soft;
  final Color text;
}

class UnitStatusBadge extends StatelessWidget {
  const UnitStatusBadge({
    required this.status,
    super.key,
    this.size = UnitStatusBadgeSize.regular,
  });

  final UnitStatus status;
  final UnitStatusBadgeSize size;

  _StatusVisual _visual(ColorScheme scheme, TsThemeExtension ext) {
    switch (status) {
      case UnitStatus.terjadwal:
      case UnitStatus.unknown:
        return _StatusVisual(
          'Terjadwal',
          Icons.schedule_rounded,
          scheme.surfaceContainerLow,
          ext.textMuted,
        );
      case UnitStatus.checkIn:
        return _StatusVisual(
          'Check-in / Antre',
          Icons.hourglass_top_rounded,
          ext.infoSoft,
          ext.infoText,
        );
      case UnitStatus.diperiksa:
        return _StatusVisual(
          'Diperiksa',
          Icons.search_rounded,
          ext.warningSoft,
          ext.warningText,
        );
      case UnitStatus.dikerjakan:
        return _StatusVisual(
          'Dikerjakan',
          Icons.build_rounded,
          scheme.primaryContainer,
          scheme.onPrimaryContainer,
        );
      case UnitStatus.qc:
        return _StatusVisual(
          'QC',
          Icons.fact_check_rounded,
          ext.warningSoft,
          ext.warningText,
        );
      case UnitStatus.selesai:
        return _StatusVisual(
          'Selesai',
          Icons.check_circle_rounded,
          ext.successSoft,
          ext.successText,
        );
      case UnitStatus.dibatalkan:
        return _StatusVisual(
          'Dibatalkan',
          Icons.cancel_rounded,
          ext.dangerSoft,
          ext.dangerText,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final ext = TsThemeExtension.of(context);
    final visual = _visual(scheme, ext);
    final compact = size == UnitStatusBadgeSize.compact;
    final textStyle = Theme.of(
      context,
    ).textTheme.labelSmall?.copyWith(color: visual.text);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 8 : 10,
        vertical: compact ? 4 : 6,
      ),
      decoration: BoxDecoration(
        color: visual.soft,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(visual.icon, size: compact ? 12 : 14, color: visual.text),
          const SizedBox(width: 4),
          Text(visual.label, style: textStyle),
        ],
      ),
    );
  }
}
