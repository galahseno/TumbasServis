import 'package:flutter/material.dart';
import 'package:tumbas_servis/booking/presentation/detail_servis/components/vehicle_tab_chip.dart';
import 'package:tumbas_servis/booking/presentation/utils/unit_config_display.dart';
import 'package:tumbas_servis/core/domain/model/garage/motor.dart';
import 'package:tumbas_servis/core/presentation/theme/ts_theme_extension.dart';

class ChipRow extends StatelessWidget {
  const ChipRow({
    required this.selectedMotorIds,
    required this.motorsById,
    required this.chipStatuses,
    required this.activeMotorId,
    required this.completeCount,
    required this.onSelect,
    super.key,
  });

  final List<String> selectedMotorIds;
  final Map<String, Motor> motorsById;
  final Map<String, UnitChipStatus> chipStatuses;
  final String activeMotorId;
  final int completeCount;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    final ext = TsThemeExtension.of(context);
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 4),
      child: Row(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (final motorId in selectedMotorIds) ...[
                    VehicleTabChip(
                      label: motorsById[motorId]?.nickname ?? motorId,
                      status: chipStatuses[motorId]!,
                      active: motorId == activeMotorId,
                      semanticLabel:
                          '${motorsById[motorId]?.nickname ?? motorId}, '
                          '${unitChipStatusLabel(chipStatuses[motorId]!)}'
                          '${motorId == activeMotorId ? ', dipilih' : ''}',
                      onTap: () => onSelect(motorId),
                    ),
                    const SizedBox(width: 8),
                  ],
                ],
              ),
            ),
          ),
          Text(
            '$completeCount/${selectedMotorIds.length} ✓',
            style: textTheme.labelMedium?.copyWith(color: ext.textMuted),
          ),
        ],
      ),
    );
  }
}
