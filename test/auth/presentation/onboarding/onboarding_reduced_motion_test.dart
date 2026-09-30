import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tumbas_servis/app/app_theme.dart';
import 'package:tumbas_servis/auth/presentation/onboarding/onboarding_page.dart';

void main() {
  Future<void> pumpOnboarding(
    WidgetTester tester, {
    required bool disableAnimations,
  }) async {
    tester.view.physicalSize = const Size(393, 852);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          theme: AppTheme.light,
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(
              context,
            ).copyWith(disableAnimations: disableAnimations),
            child: child!,
          ),
          home: const OnboardingPage(),
        ),
      ),
    );
    await tester.pump();
  }

  testWidgets('reduced motion: Lanjut jumps to the next slide instantly', (
    tester,
  ) async {
    await pumpOnboarding(tester, disableAnimations: true);
    expect(find.text('Servis banyak motor, sekali booking'), findsOneWidget);

    await tester.tap(find.text('Lanjut'));
    await tester.pump();

    expect(
      find.text('Atur servis & keluhan tiap motor secara terpisah'),
      findsOneWidget,
    );
    expect(find.text('Servis banyak motor, sekali booking'), findsNothing);
  });

  testWidgets('default motion: Lanjut still animates to the next slide', (
    tester,
  ) async {
    await pumpOnboarding(tester, disableAnimations: false);

    await tester.tap(find.text('Lanjut'));
    await tester.pumpAndSettle();

    expect(
      find.text('Atur servis & keluhan tiap motor secara terpisah'),
      findsOneWidget,
    );
  });
}
