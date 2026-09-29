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
import 'package:tumbas_servis/booking/presentation/detail_servis/detail_servis_page.dart';
import 'package:tumbas_servis/booking/presentation/pilih_jadwal/pilih_jadwal_page.dart';
import 'package:tumbas_servis/booking/presentation/pilih_motor/pilih_motor_page.dart';
import 'package:tumbas_servis/booking/presentation/ringkasan/ringkasan_page.dart';
import 'package:tumbas_servis/booking/presentation/tiket/tiket_page.dart';
import 'package:tumbas_servis/booking/presentation/voucher/voucher_page.dart';
import 'package:tumbas_servis/catalog/presentation/katalog/katalog_page.dart';
import 'package:tumbas_servis/catalog/presentation/katalog/state/katalog_state.dart';
import 'package:tumbas_servis/core/domain/model/garage/motor.dart';
import 'package:tumbas_servis/core/domain/model/result.dart';
import 'package:tumbas_servis/core/presentation/components/app_shell.dart';
import 'package:tumbas_servis/garage/presentation/garasi/garasi_page.dart';
import 'package:tumbas_servis/garage/presentation/motor_detail/motor_detail_page.dart';
import 'package:tumbas_servis/garage/presentation/motor_form/motor_form_page.dart';
import 'package:tumbas_servis/home/presentation/home/home_page.dart';
import 'package:tumbas_servis/workshop/presentation/detail_bengkel/detail_bengkel_page.dart';
import 'package:tumbas_servis/workshop/presentation/detail_bengkel/state/detail_bengkel_state.dart';
import 'package:tumbas_servis/workshop/presentation/pilih_bengkel/pilih_bengkel_page.dart';

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

      GoRoute(
        path: Routes.garageAdd,
        builder: (_, state) =>
            MotorFormPage(existingMotor: state.extra as Motor?),
      ),
      GoRoute(
        path: Routes.garageDetailTemplate,
        builder: (_, state) =>
            MotorDetailPage(motorId: state.pathParameters['id']!),
      ),

      GoRoute(
        path: Routes.bookingVehicles,
        builder: (_, state) =>
            PilihMotorPage(preselectMotorId: state.extra as String?),
      ),
      GoRoute(
        path: Routes.bookingConfigure,
        builder: (_, _) => const DetailServisPage(),
      ),
      GoRoute(
        path: Routes.bookingConfigureParts,
        builder: (_, state) => KatalogPage(
          mode: KatalogMode.select,
          selectArgs: state.extra as KatalogSelectArgs?,
        ),
      ),
      GoRoute(
        path: Routes.catalog,
        builder: (_, _) => const KatalogPage(mode: KatalogMode.browse),
      ),
      GoRoute(
        path: Routes.bookingWorkshop,
        builder: (_, _) => const PilihBengkelPage(),
      ),
      GoRoute(
        path: Routes.bookingWorkshopDetailTemplate,
        builder: (_, state) => DetailBengkelPage(
          workshopId: state.pathParameters['id']!,
          variant: WorkshopDetailVariant.inFlow,
        ),
      ),
      GoRoute(
        path: Routes.workshopDetailTemplate,
        builder: (_, state) => DetailBengkelPage(
          workshopId: state.pathParameters['id']!,
          variant: WorkshopDetailVariant.standalone,
        ),
      ),
      GoRoute(
        path: Routes.bookingSchedule,
        builder: (_, _) => const PilihJadwalPage(),
      ),
      GoRoute(
        path: Routes.bookingSummary,
        builder: (_, _) => const RingkasanPage(),
      ),
      GoRoute(
        path: Routes.bookingSummaryVoucher,
        builder: (_, _) => const VoucherPage(),
      ),
      GoRoute(
        path: Routes.bookingSuccessTemplate,
        builder: (_, state) =>
            TiketPage(bookingId: state.pathParameters['bookingId']!),
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
              GoRoute(path: Routes.home, builder: (_, _) => const HomePage()),
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
                builder: (_, _) => const GarasiPage(),
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
