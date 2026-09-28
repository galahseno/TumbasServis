import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tumbas_servis/app/navigation/routes.dart';
import 'package:tumbas_servis/auth/data/di/auth_data_module.dart';
import 'package:tumbas_servis/auth/presentation/login/login_page.dart';
import 'package:tumbas_servis/auth/presentation/onboarding/onboarding_page.dart';
import 'package:tumbas_servis/auth/presentation/otp/otp_page.dart';
import 'package:tumbas_servis/auth/presentation/splash/splash_page.dart';
import 'package:tumbas_servis/core/domain/model/result.dart';
import 'package:tumbas_servis/core/presentation/components/app_shell.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: Routes.splash,
    redirect: (context, state) => _redirect(ref, state),
    routes: [
      GoRoute(path: Routes.splash, builder: (_, _) => const SplashPage()),
      GoRoute(
        path: Routes.onboarding,
        builder: (_, _) => const OnboardingPage(),
      ),
      GoRoute(path: Routes.login, builder: (_, _) => const LoginPage()),
      GoRoute(path: Routes.otp, builder: (_, _) => const OtpPage()),
      GoRoute(
        path: Routes.notifications,
        builder: (_, _) => const Placeholder(),
      ),

      GoRoute(path: Routes.garageAdd, builder: (_, _) => const Placeholder()),
      GoRoute(
        path: Routes.garageDetailTemplate,
        builder: (_, _) => const Placeholder(),
      ),

      GoRoute(
        path: Routes.bookingVehicles,
        builder: (_, _) => const Placeholder(),
      ),
      GoRoute(
        path: Routes.bookingConfigure,
        builder: (_, _) => const Placeholder(),
      ),
      GoRoute(
        path: Routes.bookingConfigureParts,
        builder: (_, _) => const Placeholder(),
      ),
      GoRoute(path: Routes.catalog, builder: (_, _) => const Placeholder()),
      GoRoute(
        path: Routes.bookingWorkshop,
        builder: (_, _) => const Placeholder(),
      ),
      GoRoute(
        path: Routes.bookingWorkshopDetailTemplate,
        builder: (_, _) => const Placeholder(),
      ),
      GoRoute(
        path: Routes.workshopDetailTemplate,
        builder: (_, _) => const Placeholder(),
      ),
      GoRoute(
        path: Routes.bookingSchedule,
        builder: (_, _) => const Placeholder(),
      ),
      GoRoute(
        path: Routes.bookingSummary,
        builder: (_, _) => const Placeholder(),
      ),
      GoRoute(
        path: Routes.bookingSummaryVoucher,
        builder: (_, _) => const Placeholder(),
      ),
      GoRoute(
        path: Routes.bookingSuccessTemplate,
        builder: (_, _) => const Placeholder(),
      ),

      GoRoute(
        path: Routes.bookingDetailTemplate,
        builder: (_, _) => const Placeholder(),
      ),
      GoRoute(
        path: Routes.bookingUnitDetailTemplate,
        builder: (_, _) => const Placeholder(),
      ),

      GoRoute(
        path: Routes.invoiceTemplate,
        builder: (_, _) => const Placeholder(),
      ),
      GoRoute(
        path: Routes.reviewTemplate,
        builder: (_, _) => const Placeholder(),
      ),

      GoRoute(
        path: Routes.profileDemoMode,
        builder: (_, _) => const Placeholder(),
      ),

      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            AppShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.home,
                builder: (_, _) => const Placeholder(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.bookings,
                builder: (_, _) => const Placeholder(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.garage,
                builder: (_, _) => const Placeholder(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.profile,
                builder: (_, _) => const Placeholder(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});

const _redirectExempt = {Routes.splash, Routes.onboarding, Routes.otp};

Future<String?> _redirect(Ref ref, GoRouterState state) async {
  if (_redirectExempt.contains(state.matchedLocation)) return null;

  final result = await ref.read(sessionRepositoryProvider).currentUser();
  final hasSession = switch (result) {
    Ok(value: final user) => user != null,
    Error() => false,
  };
  return hasSession ? null : Routes.login;
}
