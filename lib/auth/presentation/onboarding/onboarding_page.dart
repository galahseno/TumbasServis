import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tumbas_servis/auth/presentation/di/auth_presentation_module.dart';
import 'package:tumbas_servis/auth/presentation/onboarding/components/onboarding_slide.dart';
import 'package:tumbas_servis/auth/presentation/onboarding/onboarding_view_model.dart';
import 'package:tumbas_servis/core/presentation/components/ts_button.dart';
import 'package:tumbas_servis/core/presentation/theme/ts_theme_extension.dart';

class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  final _controller = PageController();

  static const _titles = [
    'Servis banyak motor, sekali booking',
    'Atur servis & keluhan tiap motor secara terpisah',
    'Pantau status tiap unit secara real-time',
  ];

  static const _bodies = [
    'Pilih beberapa motor sekaligus, satu bengkel dan satu jadwal. '
        'Tanpa booking berulang.',
    'Tiap motor punya paket servis, suku cadang, dan keluhan sendiri, '
        'tetap dalam satu tiket.',
    'Lihat motor mana yang sedang diperiksa, dikerjakan, atau selesai, '
        'langsung dari ponselmu.',
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(onboardingViewModelProvider);
    final viewModel = ref.read(onboardingViewModelProvider.notifier);
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final ext = TsThemeExtension.of(context);
    final isLastSlide =
        state.currentSlide == OnboardingViewModel.slideCount - 1;

    return Scaffold(
      backgroundColor: scheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 55,
              child: Stack(
                children: [
                  PageView.builder(
                    controller: _controller,
                    itemCount: OnboardingViewModel.slideCount,
                    onPageChanged: viewModel.onPageChanged,
                    itemBuilder: (_, index) => OnboardingArt(slide: index),
                  ),
                  Positioned(
                    top: 16,
                    right: 16,
                    child: isLastSlide
                        ? const SizedBox.shrink()
                        : TextButton(
                            onPressed: viewModel.skip,
                            child: Text(
                              'Lewati',
                              style: textTheme.labelLarge?.copyWith(
                                color: scheme.onPrimaryContainer,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 45,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _titles[state.currentSlide],
                          style: textTheme.headlineSmall?.copyWith(
                            color: scheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _bodies[state.currentSlide],
                          style: textTheme.bodyLarge?.copyWith(
                            color: ext.textMuted,
                          ),
                        ),
                      ],
                    ),
                    PageIndicator(
                      count: OnboardingViewModel.slideCount,
                      currentIndex: state.currentSlide,
                    ),
                    TsButton(
                      label: isLastSlide ? 'Mulai' : 'Lanjut',
                      onPressed: () {
                        if (isLastSlide) {
                          viewModel.finish();
                        } else {
                          _controller.nextPage(
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.easeOut,
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
