import 'package:flutter/material.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking_unit.dart';
import 'package:tumbas_servis/core/domain/model/booking/unit_status.dart';
import 'package:tumbas_servis/core/presentation/components/ts_button.dart';
import 'package:tumbas_servis/core/presentation/components/unit_status_badge.dart';
import 'package:tumbas_servis/core/presentation/theme/ts_theme_extension.dart';

class DemoUnitRow extends StatelessWidget {
  const DemoUnitRow({
    required this.unit,
    required this.enabled,
    required this.onAdvance,
    required this.onReset,
    super.key,
  });

  final BookingUnit unit;

  final bool enabled;
  final VoidCallback onAdvance;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final ext = TsThemeExtension.of(context);
    final textTheme = Theme.of(context).textTheme;
    final name = '${unit.unitCode} ${unit.motorSnapshot.nickname}';
    final atEnd = unit.status.isTerminal;
    final canReset = unit.status != UnitStatus.terjadwal;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: scheme.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ext.borderDefault),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 4,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                name,
                style: textTheme.titleSmall?.copyWith(color: scheme.onSurface),
              ),
              UnitStatusBadge(
                status: unit.status,
                size: UnitStatusBadgeSize.compact,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: [
              Semantics(
                label:
                    'Majukan Unit ${unit.unitCode}, '
                    '${unit.motorSnapshot.nickname}',
                button: true,
                enabled: enabled && !atEnd,
                excludeSemantics: true,
                onTap: enabled && !atEnd ? onAdvance : null,
                child: TsButton(
                  label: 'Majukan',
                  type: TsButtonType.outline,
                  compact: true,
                  fullWidth: false,
                  onPressed: enabled && !atEnd ? onAdvance : null,
                ),
              ),
              Semantics(
                label:
                    'Reset Unit ${unit.unitCode}, '
                    '${unit.motorSnapshot.nickname}',
                button: true,
                enabled: enabled && canReset,
                excludeSemantics: true,
                onTap: enabled && canReset ? onReset : null,
                child: TsButton(
                  label: 'Reset',
                  type: TsButtonType.ghost,
                  compact: true,
                  fullWidth: false,
                  onPressed: enabled && canReset ? onReset : null,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
