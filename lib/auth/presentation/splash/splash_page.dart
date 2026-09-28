import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tumbas_servis/auth/presentation/di/auth_presentation_module.dart';
import 'package:tumbas_servis/core/presentation/components/ts_logo.dart';
import 'package:tumbas_servis/core/presentation/theme/ts_theme_extension.dart';

class SplashPage extends ConsumerWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(splashViewModelProvider);
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final ext = TsThemeExtension.of(context);

    return Scaffold(
      backgroundColor: scheme.surface,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const TsLogo(size: 96),
            AnimatedOpacity(
              opacity: state.showWordmark ? 1 : 0,
              duration: MediaQuery.disableAnimationsOf(context)
                  ? Duration.zero
                  : const Duration(milliseconds: 250),
              child: Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Tumbas',
                        style: textTheme.headlineSmall?.copyWith(
                          color: scheme.onSurface,
                        ),
                      ),
                      TextSpan(
                        text: 'Servis',
                        style: textTheme.headlineSmall?.copyWith(
                          color: ext.textAccent,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
