import 'package:flutter/material.dart';
import 'package:tumbas_servis/core/domain/model/booking/unit_status.dart';
import 'package:tumbas_servis/core/presentation/theme/ts_theme_extension.dart';

class FleetProgressSegment extends StatelessWidget {
  const FleetProgressSegment({required this.stage, super.key});

  final int stage;

  static const _maxStage = 5;

  @override
  Widget build(BuildContext context) {
    final ext = TsThemeExtension.of(context);
    final scheme = Theme.of(context).colorScheme;
    final fraction = (stage / _maxStage).clamp(0.0, 1.0);

    return Container(
      height: 4,
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: ext.borderDefault, width: 1),
        gradient: LinearGradient(
          colors: [scheme.primary, scheme.primary, Colors.transparent],
          stops: [0.0, fraction, fraction],
        ),
      ),
    );
  }
}

class FleetProgress extends StatelessWidget {
  const FleetProgress({
    required this.unitStatuses,
    required this.label,
    super.key,
    this.legendLabels,
  });

  final List<UnitStatus> unitStatuses;
  final String label;

  final List<String>? legendLabels;

  @override
  Widget build(BuildContext context) {
    final ext = TsThemeExtension.of(context);

    return Semantics(
      label: label,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              for (var i = 0; i < unitStatuses.length; i++) ...[
                if (i > 0) const SizedBox(width: 4),
                Expanded(
                  child: FleetProgressSegment(
                    stage: unitStatuses[i].stageIndex,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 8),
          if (legendLabels != null)
            ExcludeSemantics(
              child: Row(
                children: [
                  for (var i = 0; i < legendLabels!.length; i++) ...[
                    if (i > 0) const SizedBox(width: 4),
                    Expanded(
                      child: _LegendEntry(
                        label: legendLabels![i],
                        status: unitStatuses[i],
                      ),
                    ),
                  ],
                ],
              ),
            )
          else
            ExcludeSemantics(
              child: Text(
                label,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: ext.textMuted),
              ),
            ),
        ],
      ),
    );
  }
}

class _LegendEntry extends StatelessWidget {
  const _LegendEntry({required this.label, required this.status});

  final String label;
  final UnitStatus status;

  Color _dotColor(ColorScheme scheme, TsThemeExtension ext) => switch (status) {
    UnitStatus.terjadwal || UnitStatus.unknown => ext.textFaint,
    UnitStatus.checkIn => ext.info,
    UnitStatus.diperiksa || UnitStatus.qc => ext.warning,
    UnitStatus.dikerjakan => scheme.primary,
    UnitStatus.selesai => ext.success,
    UnitStatus.dibatalkan => ext.danger,
  };

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final ext = TsThemeExtension.of(context);
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: _dotColor(scheme, ext),
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: ext.textMuted),
          ),
        ),
      ],
    );
  }
}
