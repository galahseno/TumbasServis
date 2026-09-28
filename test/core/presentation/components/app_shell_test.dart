import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tumbas_servis/app/app_theme.dart';
import 'package:tumbas_servis/app/navigation/router.dart';
import 'package:tumbas_servis/app/navigation/routes.dart';
import 'package:tumbas_servis/auth/data/di/auth_data_module.dart';
import 'package:tumbas_servis/core/domain/model/result.dart';
import 'package:tumbas_servis/core/domain/model/user/user.dart';
import 'package:tumbas_servis/core/presentation/components/nav_bar.dart';
import 'package:tumbas_servis/core/presentation/components/nav_rail.dart';

import '../../../support/fake_session_repository.dart';

/// Substitutes for a manual on-device breakpoint check: pumps the real
/// AppShell (behind the actual router) at the PRD 06 window-size
/// breakpoints and asserts the compact->NavBar / medium+->NavRail switch.
void main() {
  late FakeSessionRepository fakeSessionRepository;
  late ProviderContainer container;

  setUp(() {
    fakeSessionRepository = FakeSessionRepository()
      ..currentUserResult = Result.ok(
        User(id: 'u1', name: 'Budi', phone: '0812'),
      );
    container = ProviderContainer(
      overrides: [
        sessionRepositoryProvider.overrideWithValue(fakeSessionRepository),
      ],
    );
  });

  tearDown(() => container.dispose());

  Future<void> pumpAtWidth(WidgetTester tester, double width) async {
    tester.view.physicalSize = Size(width, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final router = container.read(routerProvider);
    router.go(Routes.home);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp.router(theme: AppTheme.light, routerConfig: router),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('compact (< 600dp) shows the glass NavBar, no NavRail', (
    tester,
  ) async {
    await pumpAtWidth(tester, 360);
    expect(find.byType(NavBar), findsOneWidget);
    expect(find.byType(NavRail), findsNothing);
  });

  testWidgets('medium (600-839dp) shows NavRail, not extended', (tester) async {
    await pumpAtWidth(tester, 700);
    expect(find.byType(NavRail), findsOneWidget);
    expect(find.byType(NavBar), findsNothing);
    final rail = tester.widget<NavigationRail>(find.byType(NavigationRail));
    expect(rail.extended, isFalse);
  });

  testWidgets('large (>= 1200dp) shows an extended NavRail', (tester) async {
    await pumpAtWidth(tester, 1300);
    expect(find.byType(NavRail), findsOneWidget);
    final rail = tester.widget<NavigationRail>(find.byType(NavigationRail));
    expect(rail.extended, isTrue);
  });
}
