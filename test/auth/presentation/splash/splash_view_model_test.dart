import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:tumbas_servis/app/app.dart';
import 'package:tumbas_servis/app/navigation/router.dart';
import 'package:tumbas_servis/app/navigation/routes.dart';
import 'package:tumbas_servis/auth/data/di/auth_data_module.dart';
import 'package:tumbas_servis/auth/presentation/di/auth_presentation_module.dart';
import 'package:tumbas_servis/core/domain/model/result.dart';
import 'package:tumbas_servis/core/domain/model/user/user.dart';
import 'package:tumbas_servis/profile/data/di/profile_data_module.dart';

import '../../../support/fake_session_repository.dart';
import '../../../support/fake_settings_repository.dart';
import '../../../support/home_screen_fake_overrides.dart';

Future<void> _pumpAndFlush(WidgetTester tester, ProviderContainer container) {
  container.read(splashViewModelProvider);
  return tester.pump(const Duration(milliseconds: 500));
}

void main() {
  testWidgets('no session routes to onboarding after the min duration', (
    tester,
  ) async {
    final fakeSessionRepository = FakeSessionRepository()
      ..currentUserResult = const Result.ok(null);
    final container = ProviderContainer(
      overrides: [
        sessionRepositoryProvider.overrideWithValue(fakeSessionRepository),
        settingsRepositoryProvider.overrideWithValue(FakeSettingsRepository()),
        ...homeScreenFakeOverrides(),
      ],
    );
    addTearDown(container.dispose);
    final GoRouter router = container.read(routerProvider);

    await tester.pumpWidget(
      UncontrolledProviderScope(container: container, child: const App()),
    );
    container.read(splashViewModelProvider);
    expect(router.routeInformationProvider.value.uri.path, Routes.splash);

    await _pumpAndFlush(tester, container);
    await _pumpAndFlush(tester, container);
    await _pumpAndFlush(tester, container);
    await _pumpAndFlush(tester, container);

    expect(router.routeInformationProvider.value.uri.path, Routes.onboarding);
  });

  testWidgets('existing session routes straight to home', (tester) async {
    final fakeSessionRepository = FakeSessionRepository()
      ..currentUserResult = Result.ok(
        User(id: 'u1', name: 'Budi', phone: '0812'),
      );
    final container = ProviderContainer(
      overrides: [
        sessionRepositoryProvider.overrideWithValue(fakeSessionRepository),
        settingsRepositoryProvider.overrideWithValue(FakeSettingsRepository()),
        ...homeScreenFakeOverrides(),
      ],
    );
    addTearDown(container.dispose);
    final GoRouter router = container.read(routerProvider);

    await tester.pumpWidget(
      UncontrolledProviderScope(container: container, child: const App()),
    );
    container.read(splashViewModelProvider);

    await _pumpAndFlush(tester, container);
    await _pumpAndFlush(tester, container);
    await _pumpAndFlush(tester, container);
    await _pumpAndFlush(tester, container);

    expect(router.routeInformationProvider.value.uri.path, Routes.home);
  });
}
