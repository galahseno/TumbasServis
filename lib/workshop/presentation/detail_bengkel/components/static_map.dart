import 'package:flutter/material.dart';
import 'package:tumbas_servis/core/presentation/theme/ts_theme_extension.dart';

class StaticMap extends StatelessWidget {
  const StaticMap({this.height, super.key});

  final double? height;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final ext = TsThemeExtension.of(context);

    final map = ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: ColoredBox(
        color: scheme.surfaceContainerLow,
        child: Stack(
          fit: StackFit.expand,
          children: [
            CustomPaint(
              painter: _StaticMapPainter(
                roadColor: ext.borderDefault,
                blockColor: scheme.surfaceContainerHighest,
              ),
            ),
            Center(
              child: Icon(
                Icons.location_on_rounded,
                size: 40,
                color: ext.accent,
              ),
            ),
          ],
        ),
      ),
    );
    final height = this.height;
    return height == null
        ? AspectRatio(aspectRatio: 16 / 9, child: map)
        : SizedBox(height: height, width: double.infinity, child: map);
  }
}

class _StaticMapPainter extends CustomPainter {
  const _StaticMapPainter({required this.roadColor, required this.blockColor});

  final Color roadColor;
  final Color blockColor;

  @override
  void paint(Canvas canvas, Size size) {
    final blockPaint = Paint()..color = blockColor;
    final roadPaint = Paint()
      ..color = roadColor
      ..strokeWidth = 3;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          size.width * 0.08,
          size.height * 0.12,
          size.width * 0.32,
          size.height * 0.32,
        ),
        const Radius.circular(6),
      ),
      blockPaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          size.width * 0.56,
          size.height * 0.5,
          size.width * 0.36,
          size.height * 0.38,
        ),
        const Radius.circular(6),
      ),
      blockPaint,
    );
    canvas.drawLine(
      Offset(0, size.height * 0.55),
      Offset(size.width, size.height * 0.55),
      roadPaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.45, 0),
      Offset(size.width * 0.45, size.height),
      roadPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _StaticMapPainter oldDelegate) =>
      oldDelegate.roadColor != roadColor ||
      oldDelegate.blockColor != blockColor;
}
