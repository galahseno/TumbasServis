import 'package:flutter/material.dart';
import 'package:tumbas_servis/auth/presentation/onboarding/components/onboarding_slide.dart';
import 'package:tumbas_servis/core/presentation/components/ts_logo.dart';
import 'package:tumbas_servis/core/presentation/theme/ts_theme_extension.dart';

class AuthHero extends StatelessWidget {
  const AuthHero({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final ext = TsThemeExtension.of(context);
    final textTheme = Theme.of(context).textTheme;

    return ColoredBox(
      color: scheme.primaryContainer,
      child: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 48),
              child: TsLogo(markOnly: false, size: 48),
            ),
            const Expanded(child: OnboardingArt(slide: 0, maxArtWidth: 420)),
            Padding(
              padding: const EdgeInsets.fromLTRB(40, 0, 40, 56),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Servis banyak motor, sekali booking',
                    textAlign: TextAlign.center,
                    style: textTheme.headlineMedium?.copyWith(
                      color: ext.textAccent,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Satu bengkel, satu jadwal, semua motor terurus.',
                    textAlign: TextAlign.center,
                    style: textTheme.bodyLarge?.copyWith(color: ext.textBody),
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
