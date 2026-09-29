import 'dart:ui' show CheckedState;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:tumbas_servis/app/app_theme.dart';
import 'package:tumbas_servis/app/navigation/routes.dart';
import 'package:tumbas_servis/auth/data/di/auth_data_module.dart';
import 'package:tumbas_servis/core/domain/model/result.dart';
import 'package:tumbas_servis/core/domain/model/user/user.dart';
import 'package:tumbas_servis/core/domain/repository/settings/app_theme_mode.dart';
import 'package:tumbas_servis/core/presentation/components/ts_switch.dart';
import 'package:tumbas_servis/core/presentation/di/core_presentation_module.dart';
import 'package:tumbas_servis/profile/data/di/profile_data_module.dart';
import 'package:tumbas_servis/profile/presentation/profil/profil_page.dart';

import '../../../support/fake_logout_handler.dart';
import '../../../support/fake_session_repository.dart';
import '../../../support/fake_settings_repository.dart';

Future<void> _settle(WidgetTester tester) async {
  for (var i = 0; i < 10; i++) {
    await tester.pump(const Duration(milliseconds: 50));
  }
}

void main() {
  late FakeSettingsRepository settingsRepository;
  late FakeLogoutHandler logoutHandler;

  setUp(() {
    settingsRepository = FakeSettingsRepository();
    logoutHandler = FakeLogoutHandler();
  });

  Future<void> pump(
    WidgetTester tester, {
    Size size = const Size(412, 915),
    double textScale = 1,
  }) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    tester.platformDispatcher.textScaleFactorTestValue = textScale;
    addTearDown(tester.view.reset);
    addTearDown(tester.platformDispatcher.clearAllTestValues);

    final router = GoRouter(
      initialLocation: Routes.profile,
      routes: [
        GoRoute(path: Routes.profile, builder: (_, _) => const ProfilPage()),
        GoRoute(
          path: Routes.profileDemoMode,
          builder: (_, _) => const Scaffold(body: Text('demo page')),
        ),
      ],
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sessionRepositoryProvider.overrideWithValue(
            FakeSessionRepository()
              ..currentUserResult = const Result.ok(
                User(id: 'user_001', name: 'Galah', phone: '+62 812-3456-7890'),
              ),
          ),
          settingsRepositoryProvider.overrideWithValue(settingsRepository),
          logoutHandlerProvider.overrideWithValue(logoutHandler),
        ],
        child: Consumer(
          builder: (context, ref, _) => MaterialApp.router(
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: switch (ref.watch(themeModeProvider)) {
              AppThemeMode.dark => ThemeMode.dark,
              AppThemeMode.light => ThemeMode.light,
              _ => ThemeMode.system,
            },
            routerConfig: router,
          ),
        ),
      ),
    );
    await _settle(tester);
  }

  testWidgets('default: user card and every settings row', (tester) async {
    await pump(tester);

    expect(find.text('Galah'), findsOneWidget);
    expect(find.text('+62 812-****-7890'), findsOneWidget);
    expect(find.text('G'), findsOneWidget);
    expect(find.text('Tema'), findsOneWidget);
    expect(find.text('Sistem'), findsOneWidget);
    expect(find.text('Terang'), findsOneWidget);
    expect(find.text('Gelap'), findsOneWidget);
    expect(find.text('Notifikasi'), findsOneWidget);
    expect(find.text('Status servis, promo, dan pengingat'), findsOneWidget);
    expect(find.text('Mode Demo'), findsOneWidget);
    expect(find.text('Demo'), findsOneWidget);
    expect(find.text('Tentang aplikasi'), findsOneWidget);
    expect(find.text('Versi 1.0.0'), findsOneWidget);
    expect(find.text('Keluar'), findsOneWidget);
  });

  testWidgets('theme: choosing Gelap applies live and persists', (
    tester,
  ) async {
    await pump(tester);

    await tester.tap(find.text('Gelap'));
    await _settle(tester);

    expect(settingsRepository.themeMode, AppThemeMode.dark);
    final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(materialApp.themeMode, ThemeMode.dark);
  });

  testWidgets('theme control exposes a selected radio-style state', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    await pump(tester);

    final selected = tester.getSemantics(find.bySemanticsLabel('Sistem'));
    final flags = selected.getSemanticsData().flagsCollection;
    expect(flags.isChecked, CheckedState.isTrue);
    expect(flags.isInMutuallyExclusiveGroup, isTrue);
    handle.dispose();
  });

  testWidgets('notification switch toggles and persists', (tester) async {
    await pump(tester);
    expect(tester.widget<TsSwitch>(find.byType(TsSwitch)).value, isTrue);

    await tester.tap(find.text('Notifikasi'));
    await _settle(tester);

    expect(tester.widget<TsSwitch>(find.byType(TsSwitch)).value, isFalse);
    expect(settingsRepository.notificationsEnabled, isFalse);
  });

  testWidgets('Mode Demo row opens S26', (tester) async {
    await pump(tester);

    await tester.tap(find.text('Mode Demo'));
    await _settle(tester);

    expect(find.text('demo page'), findsOneWidget);
  });

  testWidgets('logout: neutral dialog; Batal keeps the session', (
    tester,
  ) async {
    await pump(tester);

    await tester.tap(find.text('Keluar'));
    await _settle(tester);
    expect(find.text('Keluar dari akun?'), findsOneWidget);
    expect(
      find.text('Data motor dan booking tetap tersimpan di perangkat ini.'),
      findsOneWidget,
    );

    await tester.tap(find.text('Batal'));
    await _settle(tester);

    expect(logoutHandler.calls, 0);
    expect(find.text('Keluar dari akun?'), findsNothing);
  });

  testWidgets('logout: confirming signs out once', (tester) async {
    await pump(tester);

    await tester.tap(find.text('Keluar'));
    await _settle(tester);

    await tester.tap(find.text('Keluar').last);
    await _settle(tester);

    expect(logoutHandler.calls, 1);
  });

  testWidgets('Tentang: sheet with version, demo note and credit', (
    tester,
  ) async {
    await pump(tester);

    await tester.tap(find.text('Tentang aplikasi'));
    await _settle(tester);

    expect(find.text('TumbasServis'), findsOneWidget);
    expect(find.text('Versi 1.0.0 (1)'), findsOneWidget);
    expect(
      find.text(
        'Aplikasi demo. Bengkel, harga, dan pembayaran hanya simulasi.',
      ),
      findsOneWidget,
    );
    expect(find.text('Dibuat oleh Galah'), findsOneWidget);
  });

  for (final (size, scale) in [
    (const Size(320, 568), 1.0),
    (const Size(360, 640), 1.3),
    (const Size(412, 915), 1.3),
  ]) {
    testWidgets('layout: no overflow at ${size.width}x${size.height} ×$scale', (
      tester,
    ) async {
      await pump(tester, size: size, textScale: scale);

      expect(tester.takeException(), isNull);
      expect(find.text('Keluar'), findsOneWidget);
    });
  }
}
