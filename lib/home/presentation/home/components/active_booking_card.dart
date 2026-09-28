import 'package:flutter/material.dart';
import 'package:tumbas_servis/core/presentation/components/fleet_progress.dart';
import 'package:tumbas_servis/core/presentation/theme/ts_theme_extension.dart';
import 'package:tumbas_servis/home/presentation/home/state/home_state.dart';

class ActiveBookingCard extends StatelessWidget {
  const ActiveBookingCard({required this.display, super.key, this.onTap});

  final HomeActiveBookingDisplay display;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final ext = TsThemeExtension.of(context);
    final textTheme = Theme.of(context).textTheme;
    final booking = display.booking;
    final unitCount = booking.units.length;

    return Semantics(
      button: true,
      label: 'Booking aktif $unitCount motor, ${display.statusLabel}',
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          constraints: const BoxConstraints(minHeight: 48),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: scheme.surfaceContainer,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: ext.borderDefault),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Booking aktif',
                      style: textTheme.labelMedium?.copyWith(
                        color: ext.textMuted,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: ext.textMuted,
                    size: 20,
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                booking.code,
                style: textTheme.titleMedium?.copyWith(color: scheme.onSurface),
              ),
              const SizedBox(height: 12),
              FleetProgress(
                unitStatuses: booking.units.map((u) => u.status).toList(),
                label: 'Motor 1 dari $unitCount: ${display.statusLabel}',
              ),
              const SizedBox(height: 8),
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 8,
                children: [
                  Text(
                    '$unitCount motor',
                    style: textTheme.bodyMedium?.copyWith(
                      color: scheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  _StatusChip(label: display.statusLabel),
                ],
              ),
              if (display.statusCaption != null) ...[
                const SizedBox(height: 4),
                Text(
                  display.statusCaption!,
                  style: textTheme.bodySmall?.copyWith(color: ext.textMuted),
                ),
              ],
              const SizedBox(height: 8),
              Divider(color: ext.borderDefault, height: 1),
              const SizedBox(height: 8),
              Text(
                display.scheduleLine,
                style: textTheme.bodySmall?.copyWith(color: ext.textMuted),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: scheme.primaryContainer,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.build_rounded, size: 14, color: scheme.onPrimaryContainer),
          const SizedBox(width: 4),
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.labelSmall?.copyWith(color: scheme.onPrimaryContainer),
          ),
        ],
      ),
    );
  }
}
