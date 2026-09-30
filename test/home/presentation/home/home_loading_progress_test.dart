import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:tumbas_servis/app/app_theme.dart';
import 'package:tumbas_servis/auth/data/di/auth_data_module.dart';
import 'package:tumbas_servis/core/data/service/demo_content_seeder.dart';
import 'package:tumbas_servis/core/domain/model/result.dart';
import 'package:tumbas_servis/core/domain/model/user/user.dart';
import 'package:tumbas_servis/home/presentation/di/home_presentation_module.dart';
import 'package:tumbas_servis/home/presentation/home/components/home_loading_progress.dart';
import 'package:tumbas_servis/home/presentation/home/home_page.dart';

import '../../../support/fake_session_repository.dart';
import '../../../support/home_screen_fake_overrides.dart';
import '../../../support/noop_demo_content_seeder.dart';

class _GatedSeeder extends NoopDemoContentSeeder {
  final gate = Completer<void>();

  @override
  Future<void> seedIfNeeded({SeedProgressCallback? onProgress}) async {
    onProgress?.call(0.5, 'Menyiapkan data demo…');
    await gate.future;
  }
}

void main() {
  setUpAll(() async {
    await initializeDateFormatting('id_ID', null);
  });

  Future<void> pumpHome(WidgetTester tester, DemoContentSeeder seeder) async {
    tester.view.physicalSize = const Size(393, 852);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          ...homeScreenFakeOverrides(),
          sessionRepositoryProvider.overrideWithValue(
            FakeSessionRepository()
              ..currentUserResult = Result.ok(
                User(id: 'u1', name: 'Budi', phone: '0812'),
              ),
          ),
          demoContentSeederProvider.overrideWithValue(seeder),
        ],
        child: MaterialApp(theme: AppTheme.light, home: const HomePage()),
      ),
    );
  }

  testWidgets('first load shows the percentage + step label, then the card '
      'disappears once loaded', (tester) async {
    final seeder = _GatedSeeder();
    await pumpHome(tester, seeder);
    await tester.pump();
    await tester.pump();

    expect(find.byType(HomeLoadingProgress), findsOneWidget);
    expect(find.text('30%'), findsOneWidget);
    expect(find.text('Menyiapkan data demo…'), findsOneWidget);

    seeder.gate.complete();
    await tester.pumpAndSettle();

    expect(find.byType(HomeLoadingProgress), findsNothing);
    expect(find.text('Halo, Budi 👋'), findsOneWidget);
  });

  testWidgets('progress card fits at text scale 1.3 without overflow', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: MediaQuery(
          data: const MediaQueryData(
            size: Size(320, 640),
            textScaler: TextScaler.linear(1.3),
          ),
          child: const Scaffold(
            body: Padding(
              padding: EdgeInsets.all(20),
              child: HomeLoadingProgress(
                progress: 0.42,
                label: 'Menyiapkan data demo untuk pertama kali…',
              ),
            ),
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(find.text('42%'), findsOneWidget);
  });
}
