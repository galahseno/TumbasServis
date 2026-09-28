import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tumbas_servis/app/navigation/router.dart';
import 'package:tumbas_servis/app/navigation/routes.dart';
import 'package:tumbas_servis/auth/data/di/auth_data_module.dart';
import 'package:tumbas_servis/auth/presentation/splash/state/splash_state.dart';
import 'package:tumbas_servis/core/domain/model/result.dart';

class SplashViewModel extends Notifier<SplashState> {
  Timer? _wordmarkTimer;
  Timer? _minDurationTimer;

  @override
  SplashState build() {
    ref.onDispose(() {
      _wordmarkTimer?.cancel();
      _minDurationTimer?.cancel();
    });
    _init();
    return const SplashState();
  }

  Future<void> _init() async {
    final sessionCheck = ref.read(sessionRepositoryProvider).currentUser();

    _wordmarkTimer = Timer(const Duration(milliseconds: 400), () {
      if (ref.mounted) state = state.copyWith(showWordmark: true);
    });

    final minDurationCompleter = Completer<void>();
    _minDurationTimer = Timer(
      const Duration(milliseconds: 800),
      minDurationCompleter.complete,
    );
    await minDurationCompleter.future;
    final sessionResult = await sessionCheck;
    if (!ref.mounted) return;

    final hasSession = switch (sessionResult) {
      Ok(value: final user) => user != null,
      Error() => false,
    };
    ref.read(routerProvider).go(hasSession ? Routes.home : Routes.onboarding);
  }
}
