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
  });

  final List<UnitStatus> unitStatuses;
  final String label;

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
