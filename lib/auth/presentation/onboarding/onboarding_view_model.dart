import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tumbas_servis/app/navigation/router.dart';
import 'package:tumbas_servis/app/navigation/routes.dart';
import 'package:tumbas_servis/auth/presentation/onboarding/state/onboarding_state.dart';

class OnboardingViewModel extends Notifier<OnboardingState> {
  static const slideCount = 3;

  @override
  OnboardingState build() => const OnboardingState();

  void onPageChanged(int index) => state = state.copyWith(currentSlide: index);

  void skip() => finish();

  void finish() => ref.read(routerProvider).go(Routes.login);
}
