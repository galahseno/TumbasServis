import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tumbas_servis/app/app_theme.dart';
import 'package:tumbas_servis/core/presentation/theme/ts_theme_extension.dart';

void main() {
  group('AppTheme', () {
    test('light colorScheme.primary is accent-fill orange-600', () {
      expect(AppTheme.light.colorScheme.primary, const Color(0xFFC24C1D));
    });

    test('dark colorScheme.primary is accent-fill orange-400', () {
      expect(AppTheme.dark.colorScheme.primary, const Color(0xFFFF8551));
    });

    testWidgets('TsThemeExtension is available on both themes', (tester) async {
      TsThemeExtension? found;
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: Builder(
            builder: (context) {
              found = TsThemeExtension.of(context);
              return const SizedBox();
            },
          ),
        ),
      );
      expect(found, isNotNull);

      found = null;
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.dark,
          home: Builder(
            builder: (context) {
              found = TsThemeExtension.of(context);
              return const SizedBox();
            },
          ),
        ),
      );
      expect(found, isNotNull);
    });

    test('labelSmall equals labelMedium (design step 12 resolution)', () {
      expect(
        AppTheme.light.textTheme.labelSmall,
        AppTheme.light.textTheme.labelMedium,
      );
      expect(
        AppTheme.dark.textTheme.labelSmall,
        AppTheme.dark.textTheme.labelMedium,
      );
    });

    test('displaySmall matches PRD 02 type scale (36/44, w600)', () {
      final style = AppTheme.light.textTheme.displaySmall!;
      expect(style.fontSize, 36);
      expect(style.fontWeight, FontWeight.w600);
      expect(style.height! * style.fontSize!, closeTo(44, 0.01));
    });
  });
}
