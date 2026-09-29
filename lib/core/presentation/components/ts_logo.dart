import 'package:flutter/material.dart';
import 'package:tumbas_servis/core/presentation/theme/ts_theme_extension.dart';

class TsLogo extends StatelessWidget {
  const TsLogo({super.key, this.markOnly = true, this.size = 40});

  final bool markOnly;
  final double size;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final mark = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: scheme.primary,
        borderRadius: BorderRadius.circular(size * 22 / 40),
      ),
      alignment: Alignment.center,
      child: Text(
        'TS',
        style: TextStyle(
          fontFamily: 'Exo 2',
          fontWeight: FontWeight.w800,
          fontVariations: const [FontVariation('wght', 800)],
          fontSize: size * 16 / 40,
          height: 1,
          color: scheme.onPrimary,
        ),
      ),
    );

    if (markOnly) return mark;

    final textTheme = Theme.of(context).textTheme;
    final extension = TsThemeExtension.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        mark,
        const SizedBox(width: 8),
        Flexible(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Tumbas',
                    style: textTheme.titleMedium?.copyWith(
                      color: scheme.onSurface,
                    ),
                  ),
                  TextSpan(
                    text: 'Servis',
                    style: textTheme.titleMedium?.copyWith(
                      color: extension.textAccent,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
