import 'package:flutter/material.dart';
import 'package:tumbas_servis/core/presentation/components/ts_button.dart';
import 'package:tumbas_servis/core/presentation/theme/ts_theme_extension.dart';

enum BookingCtaCardVariant { compact, hero }

class BookingCtaCard extends StatelessWidget {
  const BookingCtaCard({
    required this.variant,
    required this.onPressed,
    super.key,
    this.hugButton = false,
  });

  final BookingCtaCardVariant variant;
  final VoidCallback onPressed;

  final bool hugButton;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final ext = TsThemeExtension.of(context);
    final textTheme = Theme.of(context).textTheme;
    final isHero = variant == BookingCtaCardVariant.hero;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [scheme.primaryContainer, scheme.surfaceContainer],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: ext.shadowAccent,
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          if (isHero)
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  color: scheme.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(16),
                ),
                alignment: Alignment.center,
                child: Icon(
                  Icons.two_wheeler_rounded,
                  size: 56,
                  color: ext.textFaint,
                ),
              ),
            ),
          Padding(
            padding: EdgeInsets.only(right: isHero ? 108 : 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Booking servis motor',
                  style:
                      (isHero ? textTheme.headlineSmall : textTheme.titleLarge)
                          ?.copyWith(
                            color: scheme.onSurface,
                            fontWeight: FontWeight.w700,
                          ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Servis banyak motor, sekali booking.',
                  style: textTheme.bodyMedium?.copyWith(color: ext.textBody),
                ),
                const SizedBox(height: 16),
                if (hugButton)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IntrinsicWidth(
                      child: TsButton(
                        label: 'Mulai booking',
                        onPressed: onPressed,
                        type: TsButtonType.primary,
                        emphasized: true,
                        fullWidth: false,
                      ),
                    ),
                  )
                else
                  TsButton(
                    label: 'Mulai booking',
                    onPressed: onPressed,
                    type: TsButtonType.primary,
                    emphasized: true,
                    fullWidth: !isHero,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
