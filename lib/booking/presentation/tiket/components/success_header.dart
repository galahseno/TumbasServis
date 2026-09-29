import 'package:flutter/material.dart';
import 'package:tumbas_servis/core/presentation/theme/ts_theme_extension.dart';

class SuccessHeader extends StatelessWidget {
  const SuccessHeader({super.key});

  static const _entrance = Duration(milliseconds: 300);

  @override
  Widget build(BuildContext context) {
    final ext = TsThemeExtension.of(context);
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final reduceMotion = MediaQuery.disableAnimationsOf(context);

    final badge = Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(color: ext.successSoft, shape: BoxShape.circle),
      child: Icon(
        Icons.check_rounded,
        size: 40,
        weight: 700,
        color: ext.successText,
      ),
    );

    final text = Column(
      children: [
        Text(
          'Booking berhasil!',
          textAlign: TextAlign.center,
          style: textTheme.headlineSmall?.copyWith(color: scheme.onSurface),
        ),
        const SizedBox(height: 4),
        Text(
          'Tunjukkan tiket ini di bengkel saat datang.',
          textAlign: TextAlign.center,
          style: textTheme.bodyMedium?.copyWith(color: ext.textMuted),
        ),
      ],
    );

    return Semantics(
      liveRegion: true,
      container: true,
      label: 'Booking berhasil! Tunjukkan tiket ini di bengkel saat datang.',
      excludeSemantics: true,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
        child: Column(
          children: [
            if (reduceMotion)
              badge
            else
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 1),
                duration: _entrance,
                curve: Curves.easeOutBack,
                builder: (_, value, child) => Opacity(
                  opacity: value.clamp(0, 1),
                  child: Transform.scale(
                    scale: 0.25 + 0.75 * value,
                    child: child,
                  ),
                ),
                child: badge,
              ),
            const SizedBox(height: 16),
            if (reduceMotion)
              text
            else
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 1),
                duration: _entrance + const Duration(milliseconds: 100),
                curve: Curves.easeOut,
                builder: (_, value, child) => Opacity(
                  opacity: value,
                  child: Transform.translate(
                    offset: Offset(0, 8 * (1 - value)),
                    child: child,
                  ),
                ),
                child: text,
              ),
          ],
        ),
      ),
    );
  }
}
