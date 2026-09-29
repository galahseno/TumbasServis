import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:tumbas_servis/core/domain/model/workshop/mechanic.dart';
import 'package:tumbas_servis/core/presentation/theme/ts_theme_extension.dart';

class MechanicCard extends StatelessWidget {
  const MechanicCard({required this.unitCode, super.key, this.mechanic});

  final String unitCode;
  final Mechanic? mechanic;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final ext = TsThemeExtension.of(context);
    final textTheme = Theme.of(context).textTheme;
    final assigned = mechanic;
    final rating = assigned?.rating.toStringAsFixed(1).replaceAll('.', ',');

    return Semantics(
      container: true,
      label: assigned == null
          ? 'Montir unit $unitCode belum ditentukan'
          : 'Montir unit $unitCode, ${assigned.name}, rating $rating',
      excludeSemantics: true,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: scheme.surfaceContainer,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: ext.borderDefault),
        ),
        child: Row(
          children: [
            if (assigned == null)
              CustomPaint(
                painter: _DashedCirclePainter(color: ext.borderStrong),
                child: SizedBox(
                  width: 48,
                  height: 48,
                  child: Icon(
                    Icons.person_outline_rounded,
                    color: ext.textMuted,
                  ),
                ),
              )
            else
              CircleAvatar(
                radius: 24,
                backgroundColor: scheme.primaryContainer,
                child: Text(
                  assigned.avatarInitial,
                  style: textTheme.titleLarge?.copyWith(
                    color: scheme.onPrimaryContainer,
                  ),
                ),
              ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'MONTIR · UNIT ${unitCode.toUpperCase()}',
                    style: textTheme.labelSmall?.copyWith(
                      color: ext.textMuted,
                      letterSpacing: 0.6,
                    ),
                  ),
                  Text(
                    assigned?.name ?? 'Montir belum ditentukan',
                    style: textTheme.titleMedium?.copyWith(
                      color: assigned == null
                          ? ext.textMuted
                          : scheme.onSurface,
                    ),
                  ),
                  if (assigned != null)
                    Row(
                      children: [
                        Icon(
                          Icons.star_rounded,
                          size: 16,
                          color: ext.ratingStar,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          rating!,
                          style: textTheme.bodySmall?.copyWith(
                            color: ext.textMuted,
                          ),
                        ),
                      ],
                    )
                  else
                    Text(
                      'Ditentukan saat motor check-in',
                      style: textTheme.bodySmall?.copyWith(
                        color: ext.textMuted,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashedCirclePainter extends CustomPainter {
  _DashedCirclePainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    final radius = size.width / 2 - 1;
    final center = size.center(Offset.zero);
    const dashes = 16;
    const sweep = 2 * math.pi / dashes;
    for (var i = 0; i < dashes; i++) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        i * sweep,
        sweep * 0.55,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_DashedCirclePainter oldDelegate) =>
      oldDelegate.color != color;
}
