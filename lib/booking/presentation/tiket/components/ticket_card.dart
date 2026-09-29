import 'package:flutter/material.dart';
import 'package:tumbas_servis/booking/presentation/tiket/components/qr_code.dart';
import 'package:tumbas_servis/booking/presentation/tiket/components/ticket_unit_row.dart';
import 'package:tumbas_servis/booking/presentation/utils/tiket_display.dart';
import 'package:tumbas_servis/core/presentation/components/skeleton.dart';
import 'package:tumbas_servis/core/presentation/components/ts_icon_button.dart';
import 'package:tumbas_servis/core/presentation/theme/ts_theme_extension.dart';

const _notchRadius = 10.0;

class TicketCard extends StatelessWidget {
  const TicketCard({
    required this.code,
    required this.units,
    required this.workshopName,
    required this.scheduleLine,
    required this.totalLabel,
    required this.semanticsLabel,
    required this.onCopy,
    required this.onWorkshopTap,
    super.key,
  });

  final String code;
  final List<TicketUnitLine> units;
  final String workshopName;
  final String scheduleLine;
  final String totalLabel;
  final String semanticsLabel;
  final VoidCallback onCopy;
  final VoidCallback onWorkshopTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final ext = TsThemeExtension.of(context);
    final textTheme = Theme.of(context).textTheme;

    return _TicketShell(
      top: Semantics(
        container: true,
        label: semanticsLabel,
        child: Column(
          children: [
            Text(
              'Kode booking',
              style: textTheme.bodySmall?.copyWith(color: ext.textMuted),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    code,
                    textAlign: TextAlign.center,
                    style: textTheme.headlineSmall?.copyWith(
                      color: scheme.onSurface,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                ),
                TsIconButton(
                  icon: Icons.content_copy_rounded,
                  semanticLabel: 'Salin kode booking',
                  onPressed: onCopy,
                ),
              ],
            ),
            const SizedBox(height: 12),
            BookingQrCode(data: code),
          ],
        ),
      ),
      middle: Column(
        children: [for (final line in units) TicketUnitRow(line: line)],
      ),
      bottom: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Semantics(
            button: true,
            label: 'Lihat bengkel $workshopName',
            excludeSemantics: true,
            child: InkWell(
              onTap: onWorkshopTap,
              borderRadius: BorderRadius.circular(8),
              child: ConstrainedBox(
                constraints: const BoxConstraints(minHeight: 48),
                child: Row(
                  children: [
                    Icon(
                      Icons.storefront_rounded,
                      size: 20,
                      color: ext.textMuted,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        workshopName,
                        style: textTheme.titleSmall?.copyWith(
                          color: scheme.onSurface,
                        ),
                      ),
                    ),
                    Icon(Icons.chevron_right_rounded, color: ext.textMuted),
                  ],
                ),
              ),
            ),
          ),
          Row(
            children: [
              Icon(Icons.event_rounded, size: 20, color: ext.textMuted),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  scheduleLine,
                  style: textTheme.bodyMedium?.copyWith(
                    color: scheme.onSurface,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            totalLabel,
            style: textTheme.bodyMedium?.copyWith(color: ext.textMuted),
          ),
        ],
      ),
    );
  }
}

class TicketCardSkeleton extends StatelessWidget {
  const TicketCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final ext = TsThemeExtension.of(context);
    final textTheme = Theme.of(context).textTheme;

    return _TicketShell(
      top: Column(
        children: [
          Text(
            'Membuat tiket…',
            style: textTheme.bodyMedium?.copyWith(color: ext.textMuted),
          ),
          const SizedBox(height: 12),
          const SkeletonLine(width: 180, height: 24),
          const SizedBox(height: 12),
          const SkeletonBlock(width: 176, height: 176),
        ],
      ),
      middle: const Column(
        children: [
          SkeletonBlock(height: 44),
          SizedBox(height: 8),
          SkeletonBlock(height: 44),
          SizedBox(height: 8),
          SkeletonBlock(height: 44),
        ],
      ),
      bottom: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SkeletonLine(width: 200),
          SizedBox(height: 8),
          SkeletonLine(width: 160),
          SizedBox(height: 8),
          SkeletonLine(width: 220),
        ],
      ),
    );
  }
}

class _TicketShell extends StatelessWidget {
  const _TicketShell({
    required this.top,
    required this.middle,
    required this.bottom,
  });

  final Widget top;
  final Widget middle;
  final Widget bottom;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final ext = TsThemeExtension.of(context);

    Widget tearLine() => SizedBox(
      height: _notchRadius * 2,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: _notchRadius + 4),
            child: CustomPaint(
              size: const Size(double.infinity, 1),
              painter: _DashedLinePainter(ext.borderDefault),
            ),
          ),
          Positioned(
            left: -_notchRadius,
            child: _Notch(color: scheme.surface),
          ),
          Positioned(
            right: -_notchRadius,
            child: _Notch(color: scheme.surface),
          ),
        ],
      ),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: scheme.surfaceContainer,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: ext.borderDefault),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
              child: top,
            ),
            tearLine(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: middle,
            ),
            tearLine(),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              child: bottom,
            ),
          ],
        ),
      ),
    );
  }
}

class _Notch extends StatelessWidget {
  const _Notch({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) => Container(
    width: _notchRadius * 2,
    height: _notchRadius * 2,
    decoration: BoxDecoration(color: color, shape: BoxShape.circle),
  );
}

class _DashedLinePainter extends CustomPainter {
  const _DashedLinePainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;
    const dash = 6.0;
    const gap = 4.0;
    var x = 0.0;
    while (x < size.width) {
      canvas.drawLine(
        Offset(x, 0),
        Offset((x + dash).clamp(0, size.width), 0),
        paint,
      );
      x += dash + gap;
    }
  }

  @override
  bool shouldRepaint(_DashedLinePainter old) => old.color != color;
}
