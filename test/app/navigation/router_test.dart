import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:tumbas_servis/app/app.dart';
import 'package:tumbas_servis/app/navigation/router.dart';
import 'package:tumbas_servis/app/navigation/routes.dart';
import 'package:tumbas_servis/auth/data/di/auth_data_module.dart';
import 'package:tumbas_servis/auth/presentation/di/auth_presentation_module.dart';
import 'package:tumbas_servis/auth/presentation/otp/otp_view_model.dart';
import 'package:tumbas_servis/core/domain/model/result.dart';
import 'package:tumbas_servis/core/domain/model/user/user.dart';
import 'package:tumbas_servis/profile/data/di/profile_data_module.dart';

import '../../support/fake_session_repository.dart';
import '../../support/fake_settings_repository.dart';
import '../../support/home_screen_fake_overrides.dart';
import '../../support/manual_timer_factory.dart';

const _allRoutePaths = [
  Routes.splash,
  Routes.onboarding,
  Routes.login,
  Routes.otp,
  Routes.home,
  Routes.notifications,
  Routes.garage,
  Routes.garageAdd,
  '/garage/123',
  Routes.bookingVehicles,
  Routes.bookingConfigure,
  Routes.bookingConfigureParts,
  Routes.catalog,
  Routes.bookingWorkshop,
  '/booking/workshop/w1',
  '/workshops/w1',
  Routes.bookingSchedule,
  Routes.bookingSummary,
  Routes.bookingSummaryVoucher,
  '/booking/success/b1',
  Routes.bookings,
  '/bookings/b1',
  '/bookings/b1/unit/u1',
  '/invoice/b1',
  '/review/b1',
  Routes.profile,
  Routes.profileDemoMode,
];

void main() {
  late FakeSessionRepository fakeSessionRepository;
  late ProviderContainer container;
  late GoRouter router;

  setUpAll(() async {
    await initializeDateFormatting('id_ID', null);
  });

  setUp(() {
    fakeSessionRepository = FakeSessionRepository();
    container = ProviderContainer(
      overrides: [
        sessionRepositoryProvider.overrideWithValue(fakeSessionRepository),
        settingsRepositoryProvider.overrideWithValue(FakeSettingsRepository()),
        // /otp starts a real countdown Timer; a manual (never auto-firing)
        // factory keeps no real Timer pending past this test's end.
        otpViewModelProvider.overrideWith(
          () => OtpViewModel(timerFactory: ManualTimerFactory().call),
        ),
        ...homeScreenFakeOverrides(),
      ],
    );
    router = container.read(routerProvider);
  });

  tearDown(() => container.dispose());

  Future<void> pumpRouter(WidgetTester tester) async {
    await tester.pumpWidget(
      UncontrolledProviderScope(container: container, child: const App()),
    );
  }

  String currentPath() => router.routeInformationProvider.value.uri.path;

  group('router redirect', () {
    testWidgets('no session, /home redirects to /login', (tester) async {
      fakeSessionRepository.currentUserResult = const Result.ok(null);
      await pumpRouter(tester);

      router.go(Routes.home);
      await tester.pumpAndSettle();

      expect(currentPath(), Routes.login);
    });

    for (final exempt in [Routes.splash, Routes.onboarding, Routes.otp]) {
      testWidgets('no session, $exempt stays put (exempt)', (tester) async {
        fakeSessionRepository.currentUserResult = const Result.ok(null);
        await pumpRouter(tester);

        router.go(exempt);
        await tester.pumpAndSettle();

        expect(currentPath(), exempt);

        // Splash's own pending navigation timer (no session -> onboarding)
        // would otherwise still be pending when the container disposes at
        // tearDown; let it run to completion so no real Timer leaks past
        // this test.
        if (exempt == Routes.splash) {
          await tester.pump(const Duration(milliseconds: 900));
          await tester.pumpAndSettle();
        }
      });
    }

    testWidgets('session present, /home stays at /home', (tester) async {
      fakeSessionRepository.currentUserResult = Result.ok(
        User(id: 'u1', name: 'Budi', phone: '0812'),
      );
      await pumpRouter(tester);

      router.go(Routes.home);
      await tester.pumpAndSettle();

      expect(currentPath(), Routes.home);
    });
  });

  testWidgets('every declared route resolves without throwing', (tester) async {
    fakeSessionRepository.currentUserResult = Result.ok(
      User(id: 'u1', name: 'Budi', phone: '0812'),
    );
    await pumpRouter(tester);

    for (final path in _allRoutePaths) {
      router.go(path);
      await tester.pumpAndSettle();
      expect(
        currentPath(),
        path,
        reason: 'route $path should match and not redirect away',
      );
    }
  });
}
