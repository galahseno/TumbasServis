import 'package:flutter/material.dart';
import 'package:tumbas_servis/core/domain/model/booking/unit_status.dart';
import 'package:tumbas_servis/core/presentation/components/unit_status_badge.dart';
import 'package:tumbas_servis/core/presentation/theme/ts_theme_extension.dart';

class VehicleSelectCard extends StatelessWidget {
  const VehicleSelectCard({
    required this.nickname,
    required this.plateNumber,
    super.key,
    this.inServiceStatus,
    this.onTap,
  });

  final String nickname;
  final String plateNumber;
  final UnitStatus? inServiceStatus;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final ext = TsThemeExtension.of(context);
    final textTheme = Theme.of(context).textTheme;

    return Semantics(
      button: onTap != null,
      label: inServiceStatus == null
          ? nickname
          : '$nickname, sedang dikerjakan',
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: 124,
          padding: const EdgeInsets.all(12),
          constraints: const BoxConstraints(minHeight: 48),
          decoration: BoxDecoration(
            color: scheme.surfaceContainer,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: ext.borderDefault),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 64,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: scheme.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Icon(
                  Icons.two_wheeler_rounded,
                  size: 32,
                  color: ext.textFaint,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                nickname,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: textTheme.labelLarge?.copyWith(color: scheme.onSurface),
              ),
              Text(
                plateNumber,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textTheme.bodySmall?.copyWith(color: ext.textMuted),
              ),
              if (inServiceStatus != null) ...[
                const SizedBox(height: 6),
                UnitStatusBadge(
                  status: inServiceStatus!,
                  size: UnitStatusBadgeSize.compact,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
