import 'package:flutter/material.dart';
import 'package:tumbas_servis/core/domain/model/booking/unit_status.dart';
import 'package:tumbas_servis/core/presentation/components/unit_status_badge.dart';
import 'package:tumbas_servis/core/presentation/theme/ts_theme_extension.dart';

enum VehicleSelectCardLayout { compact, wide }

class VehicleSelectCard extends StatelessWidget {
  const VehicleSelectCard({
    required this.nickname,
    required this.plateNumber,
    super.key,
    this.inServiceStatus,
    this.onTap,
    this.layout = VehicleSelectCardLayout.compact,
    this.caption,
  });

  final String nickname;
  final String plateNumber;
  final UnitStatus? inServiceStatus;
  final VoidCallback? onTap;
  final VehicleSelectCardLayout layout;
  final String? caption;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final ext = TsThemeExtension.of(context);
    final textTheme = Theme.of(context).textTheme;

    if (layout == VehicleSelectCardLayout.wide) return _buildWide(context);

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

  Widget _buildWide(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final ext = TsThemeExtension.of(context);
    final textTheme = Theme.of(context).textTheme;

    return Semantics(
      button: onTap != null,
      label: inServiceStatus == null
          ? '$nickname, $plateNumber${caption == null ? '' : ', $caption'}'
          : '$nickname, $plateNumber, sedang dikerjakan',
      excludeSemantics: true,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          constraints: const BoxConstraints(minHeight: 48),
          decoration: BoxDecoration(
            color: scheme.surfaceContainer,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: ext.borderDefault),
          ),
          child: Row(
            children: [
              Container(
                height: 64,
                width: 64,
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
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      nickname,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.titleMedium?.copyWith(
                        color: scheme.onSurface,
                      ),
                    ),
                    Text(
                      plateNumber,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.bodyMedium?.copyWith(
                        color: ext.textBody,
                      ),
                    ),
                    if (caption != null)
                      Text(
                        caption!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.bodySmall?.copyWith(
                          color: ext.textMuted,
                        ),
                      ),
                    if (inServiceStatus != null) ...[
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: UnitStatusBadge(
                            status: inServiceStatus!,
                            size: UnitStatusBadgeSize.compact,
                          ),
                        ),
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
