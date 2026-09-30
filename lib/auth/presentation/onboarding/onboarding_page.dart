import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tumbas_servis/auth/presentation/di/auth_presentation_module.dart';
import 'package:tumbas_servis/auth/presentation/onboarding/components/onboarding_slide.dart';
import 'package:tumbas_servis/auth/presentation/onboarding/onboarding_view_model.dart';
import 'package:tumbas_servis/auth/presentation/onboarding/state/onboarding_state.dart';
import 'package:tumbas_servis/core/presentation/components/ts_button.dart';
import 'package:tumbas_servis/core/presentation/theme/ts_theme_extension.dart';
import 'package:tumbas_servis/core/presentation/utils/window_size_class.dart';

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

  void _next(OnboardingViewModel viewModel, bool isLastSlide) {
    if (isLastSlide) {
      viewModel.finish();
    } else if (MediaQuery.disableAnimationsOf(context)) {
      _controller.jumpToPage((_controller.page ?? 0).round() + 1);
    } else {
      _controller.nextPage(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    }
  }

  Widget _art({double? maxArtWidth}) => PageView.builder(
    controller: _controller,
    itemCount: OnboardingViewModel.slideCount,
    onPageChanged: ref.read(onboardingViewModelProvider.notifier).onPageChanged,
    itemBuilder: (_, index) =>
        OnboardingArt(slide: index, maxArtWidth: maxArtWidth),
  );

  Widget _skip(ColorScheme scheme, TextTheme textTheme) => TextButton(
    onPressed: ref.read(onboardingViewModelProvider.notifier).skip,
    child: Text(
      'Lewati',
      style: textTheme.labelLarge?.copyWith(
        color: scheme.onPrimaryContainer,
        fontWeight: FontWeight.w600,
      ),
    ),
  );

  Widget _copy({
    required int slide,
    required bool isLastSlide,
    required OnboardingViewModel viewModel,
    required TextStyle? titleStyle,
  }) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final ext = TsThemeExtension.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _titles[slide],
          style: (titleStyle ?? textTheme.headlineSmall)?.copyWith(
            color: scheme.onSurface,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          _bodies[slide],
          style: textTheme.bodyLarge?.copyWith(color: ext.textMuted),
        ),
        const SizedBox(height: 24),
        PageIndicator(
          count: OnboardingViewModel.slideCount,
          currentIndex: slide,
        ),
        const SizedBox(height: 24),
        TsButton(
          label: isLastSlide ? 'Mulai' : 'Lanjut',
          onPressed: () => _next(viewModel, isLastSlide),
        ),
      ],
    );
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
    final sizeClass = context.windowSizeClass;

    if (sizeClass.isAtLeast(WindowSizeClass.expanded)) {
      return _buildSplit(
        state: state,
        viewModel: viewModel,
        isLastSlide: isLastSlide,
        scheme: scheme,
        textTheme: textTheme,
      );
    }
    if (sizeClass == WindowSizeClass.medium) {
      return _buildCard(
        state: state,
        viewModel: viewModel,
        isLastSlide: isLastSlide,
        scheme: scheme,
        textTheme: textTheme,
        ext: ext,
      );
    }

    return Scaffold(
      backgroundColor: scheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 55,
              child: Stack(
                children: [
                  _art(),
                  Positioned(
                    top: 16,
                    right: 16,
                    child: isLastSlide
                        ? const SizedBox.shrink()
                        : _skip(scheme, textTheme),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 45,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                child: LayoutBuilder(
                  builder: (context, constraints) => SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: IntrinsicHeight(
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
                              onPressed: () => _next(viewModel, isLastSlide),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard({
    required OnboardingState state,
    required OnboardingViewModel viewModel,
    required bool isLastSlide,
    required ColorScheme scheme,
    required TextTheme textTheme,
    required TsThemeExtension ext,
  }) {
    return Scaffold(
      backgroundColor: scheme.surface,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 560),
                  child: Container(
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      color: scheme.surfaceContainer,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: ext.borderDefault),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(height: 440, child: _art(maxArtWidth: 300)),
                        Padding(
                          padding: const EdgeInsets.all(40),
                          child: _copy(
                            slide: state.currentSlide,
                            isLastSlide: isLastSlide,
                            viewModel: viewModel,
                            titleStyle: textTheme.headlineLarge,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            if (!isLastSlide)
              Positioned(
                top: 16,
                right: 16,
                child: TextButton(
                  onPressed: viewModel.skip,
                  child: Text(
                    'Lewati',
                    style: textTheme.labelLarge?.copyWith(
                      color: scheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSplit({
    required OnboardingState state,
    required OnboardingViewModel viewModel,
    required bool isLastSlide,
    required ColorScheme scheme,
    required TextTheme textTheme,
  }) {
    return Scaffold(
      backgroundColor: scheme.surface,
      body: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 24,
                  ),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 480),
                    child: _copy(
                      slide: state.currentSlide,
                      isLastSlide: isLastSlide,
                      viewModel: viewModel,
                      titleStyle: textTheme.displaySmall,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  _art(maxArtWidth: 420),
                  Positioned(
                    top: 16,
                    right: 16,
                    child: isLastSlide
                        ? const SizedBox.shrink()
                        : _skip(scheme, textTheme),
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
