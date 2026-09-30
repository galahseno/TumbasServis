import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tumbas_servis/app/app_theme.dart';
import 'package:tumbas_servis/core/domain/repository/settings/app_theme_mode.dart';
import 'package:tumbas_servis/profile/presentation/profil/components/theme_preview.dart';

void main() {
  Future<void> pump(
    WidgetTester tester,
    AppThemeMode mode, {
    Brightness platform = Brightness.light,
  }) async {
    tester.platformDispatcher.platformBrightnessTestValue = platform;
    addTearDown(tester.platformDispatcher.clearAllTestValues);
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(body: ThemePreview(mode: mode)),
      ),
    );
  }

  Brightness previewBrightness(WidgetTester tester) => tester
      .widget<Theme>(
        find
            .descendant(
              of: find.byType(ThemePreview),
              matching: find.byType(Theme),
            )
            .first,
      )
      .data
      .brightness;

  testWidgets('dark preview renders dark inside a light app', (tester) async {
    await pump(tester, AppThemeMode.dark);

    expect(previewBrightness(tester), Brightness.dark);
    expect(
      Theme.of(tester.element(find.byType(ThemePreview))).brightness,
      Brightness.light,
    );
    expect(find.text('Gelap'), findsOneWidget);
    expect(find.text('Selalu gelap.'), findsOneWidget);
  });

  testWidgets('light preview stays light', (tester) async {
    await pump(tester, AppThemeMode.light);

    expect(previewBrightness(tester), Brightness.light);
    expect(find.text('Selalu terang.'), findsOneWidget);
  });

  testWidgets('system preview follows the device brightness', (tester) async {
    await pump(tester, AppThemeMode.system, platform: Brightness.dark);

    expect(previewBrightness(tester), Brightness.dark);
    expect(find.text('Sistem'), findsOneWidget);
    expect(find.text('Mengikuti pengaturan perangkat.'), findsOneWidget);
  });
}
