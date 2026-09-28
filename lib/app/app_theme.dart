import 'package:flutter/material.dart';
import 'package:tumbas_servis/core/presentation/theme/ts_theme_extension.dart';

abstract final class AppTheme {
  static ThemeData get light => _build(brightness: Brightness.light);
  static ThemeData get dark => _build(brightness: Brightness.dark);

  static ThemeData _build({required Brightness brightness}) {
    final isDark = brightness == Brightness.dark;
    final scheme = isDark ? _darkScheme : _lightScheme;
    final extension = isDark ? _darkExtension : _lightExtension;

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: scheme.surface,
      applyElevationOverlayColor: false,
      fontFamily: 'Exo 2',
      textTheme: _buildTextTheme(
        headingColor: scheme.onSurface,
        bodyColor: extension.textBody,
      ),
      extensions: [extension],
    );
  }

  static const _lightScheme = ColorScheme.light(
    primary: Color(0xFFC24C1D), // accent-fill (orange-600)
    onPrimary: Color(0xFFFFFFFF), // text-on-accent
    primaryContainer: Color(0xFFFFE8DB), // accent-soft (orange-100)
    onPrimaryContainer: Color(0xFFB04418), // text-on-accent-soft (orange-700)
    surface: Color(0xFFFBFAF9), // bg-page (sand-50)
    surfaceContainerLowest: Color(0xFFF4F1EE), // surface-inset (sand-100)
    surfaceContainerLow: Color(0xFFF4F1EE),
    surfaceContainer: Color(0xFFFFFFFF), // surface-card (sand-0)
    surfaceContainerHigh: Color(0xFFFFFFFF),
    surfaceContainerHighest: Color(0xFFFFFFFF),
    surfaceTint: Colors.transparent,
    onSurface: Color(0xFF1A1716), // text-heading (sand-900)
    onSurfaceVariant: Color(0xFF756C65), // text-muted (sand-600)
    outline: Color(0xFF8A817A), // border-control (sand-500)
    outlineVariant: Color(0xFFE8E3DE), // border-subtle (sand-200)
    error: Color(0xFFCC291F), // danger-fill (red-700)
    onError: Color(0xFFFFFFFF), // text-on-danger
    errorContainer: Color(0xFFFCEBEA), // danger-soft (red-100)
    onErrorContainer: Color(0xFFCC291F), // danger-text (red-700)
    inverseSurface: Color(0xFF1A1716), // surface-inverse (sand-900)
    onInverseSurface: Color(0xFFFBFAF9), // text-on-inverse (sand-50)
    inversePrimary: Color(0xFFFFAE81), // accent-on-inverse (orange-300)
  );

  static const _darkScheme = ColorScheme.dark(
    primary: Color(0xFFFF8551), // accent-fill (orange-400)
    onPrimary: Color(0xFF1A0E07),
    primaryContainer: Color(0x29FF8551), // orange-400 @ 16%
    onPrimaryContainer: Color(0xFFFF8551),
    surface: Color(0xFF100E0D), // bg-page (sand-950)
    surfaceContainerLowest: Color(0xFF141211), // surface-inset
    surfaceContainerLow: Color(0xFF141211),
    surfaceContainer: Color(0xFF191615), // surface-card
    surfaceContainerHigh: Color(0xFF191615),
    surfaceContainerHighest: Color(0xFF191615),
    surfaceTint: Colors.transparent,
    onSurface: Color(0xFFF7F4F2), // text-heading
    onSurfaceVariant: Color(0xFF9A918B), // text-muted
    outline: Color(0xFF6C645F), // border-control
    outlineVariant: Color(0xFF282422), // border-subtle
    error: Color(0xFFE76861), // danger-fill (red-300)
    onError: Color(0xFF1A0E07),
    errorContainer: Color(0x29E4574F), // red-400 @ 16%
    onErrorContainer: Color(0xFFE76861), // danger-text (red-300)
    inverseSurface: Color(0xFFF4F1EE), // surface-inverse (sand-100)
    onInverseSurface: Color(0xFF1A1716), // text-on-inverse (sand-900)
    inversePrimary: Color(0xFFB04418), // accent-on-inverse (orange-700)
  );

  static const _lightExtension = TsThemeExtension(
    textBody: Color(0xFF463F3A), // sand-700
    textMuted: Color(0xFF756C65), // sand-600
    textFaint: Color(0xFFB0A79F), // sand-400
    textAccent: Color(0xFFC24C1D), // orange-600
    accent: Color(0xFFE4622F), // orange-500 (non-text brand surfaces)
    accentHover: Color(0xFFC24C1D), // orange-600
    accentPressed: Color(0xFFB04418), // orange-700
    borderDefault: Color(0xFFD6CFC8), // sand-300
    borderStrong: Color(0xFFB0A79F), // sand-400
    borderAccent: Color(0xFFE4622F), // orange-500
    focusRing: Color(0xFFC24C1D), // orange-600
    success: Color(0xFF4FB477), // green-400
    successText: Color(0xFF33794F), // green-700
    successSoft: Color(0xFFEAF6EF), // green-100
    warning: Color(0xFFD99A2B), // warning-400
    warningText: Color(0xFF8F641A), // warning-700
    warningSoft: Color(0xFFFAF3E6), // warning-100
    info: Color(0xFF5B8DEF), // info-400
    infoText: Color(0xFF1F63E9), // info-700
    infoSoft: Color(0xFFEBF1FD), // info-100
    danger: Color(0xFFE4574F), // red-400
    dangerText: Color(0xFFCC291F), // red-700
    dangerSoft: Color(0xFFFCEBEA), // red-100
    dangerPressed: Color(0xFFB3231A),
    ratingStar: Color(0xFF8F641A), // warning-700
    textOnInverse: Color(0xFFFBFAF9), // sand-50
    accentOnInverse: Color(0xFFFFAE81), // orange-300
    skeletonBase: Color(0xFFE8E3DE), // sand-200
    skeletonHighlight: Color(0xFFFFFFFF),
    illustrationOutline: Color(0x141A1716), // sand-900 @ 8%
    statePressed: Color(0x1A1A1716), // sand-900 @ 10%
    bgPageClear: Color(0x00FBFAF9), // sand-50 @ 0%
    scrim: Color(0x661A1716), // sand-900 @ 40%
    glassTint: Color(0x6BFFFFFF), // sand-0 @ 42%
    glassTintStrong: Color(0xCCFFFFFF), // sand-0 @ 80%
    glassBorder: Color(0x141A1716), // sand-900 @ 8%
    glassSheenTop: Color(0xBFFFFFFF),
    glassSheenBottom: Color(0x40FFFFFF),
    shadowSm: [
      BoxShadow(color: Color(0x0F1A1716), offset: Offset(0, 1), blurRadius: 2),
      BoxShadow(
        color: Color(0x1E1A1716),
        offset: Offset(0, 4),
        blurRadius: 12,
        spreadRadius: -4,
      ),
    ],
    shadowMd: [
      BoxShadow(color: Color(0x141A1716), offset: Offset(0, 2), blurRadius: 4),
      BoxShadow(
        color: Color(0x2E1A1716),
        offset: Offset(0, 14),
        blurRadius: 28,
        spreadRadius: -10,
      ),
    ],
    shadowAccent: [
      BoxShadow(
        color: Color(0x59E4622F),
        offset: Offset(0, 10),
        blurRadius: 26,
        spreadRadius: -8,
      ),
    ],
    glassShadow: [
      BoxShadow(color: Color(0x0A1A1716), offset: Offset(0, 1), blurRadius: 1),
      BoxShadow(
        color: Color(0x2E1A1716),
        offset: Offset(0, 8),
        blurRadius: 28,
        spreadRadius: -8,
      ),
    ],
  );

  static const _darkExtension = TsThemeExtension(
    textBody: Color(0xFFC9C1BB),
    textMuted: Color(0xFF9A918B),
    textFaint: Color(0xFF6C645F),
    textAccent: Color(0xFFFF8551), // orange-400
    accent: Color(0xFFFF8551),
    accentHover: Color(0xFFFFAE81), // orange-300
    accentPressed: Color(0xFFFFAE81),
    borderDefault: Color(0xFF363130),
    borderStrong: Color(0xFF4B4442),
    borderAccent: Color(0xFFFF8551),
    focusRing: Color(0xFFFF8551),
    success: Color(0xFF4FB477),
    successText: Color(0xFF4FB477),
    successSoft: Color(0x294FB477), // green-400 @ 16%
    warning: Color(0xFFD99A2B),
    warningText: Color(0xFFD99A2B),
    warningSoft: Color(0x29D99A2B), // warning-400 @ 16%
    info: Color(0xFF5B8DEF),
    infoText: Color(0xFF6090EF), // info-300
    infoSoft: Color(0x295B8DEF), // info-400 @ 16%
    danger: Color(0xFFE4574F),
    dangerText: Color(0xFFE76861), // red-300
    dangerSoft: Color(0x29E4574F), // red-400 @ 16%
    dangerPressed: Color(0xFFEE8580),
    ratingStar: Color(0xFFD99A2B), // warning-400
    textOnInverse: Color(0xFF1A1716), // sand-900
    accentOnInverse: Color(0xFFB04418), // orange-700
    skeletonBase: Color(0xFF282422),
    skeletonHighlight: Color(0xFF363130),
    illustrationOutline: Color(0x1AFFFFFF),
    statePressed: Color(0x1FFFFFFF),
    bgPageClear: Color(0x00100E0D), // sand-950 @ 0%
    scrim: Color(0xA6000000),
    glassTint: Color(0x661C1918), // #1C1918 @ 40%
    glassTintStrong: Color(0xCC1C1918), // #1C1918 @ 80%
    glassBorder: Color(0x1AFFFFFF),
    glassSheenTop: Color(0x17FFFFFF),
    glassSheenBottom: Color(0x08FFFFFF),
    shadowSm: [
      BoxShadow(color: Color(0x80000000), offset: Offset(0, 1), blurRadius: 2),
      BoxShadow(
        color: Color(0x99000000),
        offset: Offset(0, 4),
        blurRadius: 14,
        spreadRadius: -4,
      ),
    ],
    shadowMd: [
      BoxShadow(color: Color(0x8C000000), offset: Offset(0, 2), blurRadius: 4),
      BoxShadow(
        color: Color(0xB3000000),
        offset: Offset(0, 16),
        blurRadius: 32,
        spreadRadius: -10,
      ),
    ],
    shadowAccent: [
      BoxShadow(
        color: Color(0x42FF8551),
        offset: Offset(0, 10),
        blurRadius: 26,
        spreadRadius: -8,
      ),
    ],
    glassShadow: [
      BoxShadow(color: Color(0x66000000), offset: Offset(0, 1), blurRadius: 1),
      BoxShadow(
        color: Color(0xB3000000),
        offset: Offset(0, 10),
        blurRadius: 30,
        spreadRadius: -10,
      ),
    ],
  );

  static TextTheme _buildTextTheme({
    required Color headingColor,
    required Color bodyColor,
  }) {
    final labelMedium = _exo2(
      size: 12,
      lineHeight: 16,
      weight: 600,
      trackingEm: 0.025,
      color: headingColor,
    );

    return TextTheme(
      displaySmall: _exo2(
        size: 36,
        lineHeight: 44,
        weight: 600,
        trackingEm: -0.025,
        color: headingColor,
      ),
      headlineLarge: _exo2(
        size: 28,
        lineHeight: 34,
        weight: 600,
        trackingEm: -0.025,
        color: headingColor,
      ),
      headlineSmall: _exo2(
        size: 22,
        lineHeight: 28,
        weight: 600,
        trackingEm: -0.025,
        color: headingColor,
      ),
      titleLarge: _exo2(
        size: 20,
        lineHeight: 26,
        weight: 600,
        trackingEm: 0,
        color: headingColor,
      ),
      titleMedium: _exo2(
        size: 16,
        lineHeight: 22,
        weight: 600,
        trackingEm: 0,
        color: headingColor,
      ),
      bodyLarge: _exo2(
        size: 16,
        lineHeight: 24,
        weight: 400,
        trackingEm: 0,
        color: bodyColor,
      ),
      bodyMedium: _exo2(
        size: 14,
        lineHeight: 22,
        weight: 400,
        trackingEm: 0,
        color: bodyColor,
      ),
      bodySmall: _exo2(
        size: 12,
        lineHeight: 18,
        weight: 400,
        trackingEm: 0,
        color: bodyColor,
      ),
      labelLarge: _exo2(
        size: 14,
        lineHeight: 20,
        weight: 600,
        trackingEm: 0.025,
        color: headingColor,
      ),
      labelMedium: labelMedium,
      labelSmall: labelMedium,
    );
  }

  static TextStyle _exo2({
    required double size,
    required double lineHeight,
    required int weight,
    required double trackingEm,
    Color? color,
  }) {
    return TextStyle(
      fontFamily: 'Exo 2',
      fontSize: size,
      height: lineHeight / size, // Flutter's `height` is a multiplier
      fontWeight: FontWeight.values[(weight ~/ 100) - 1],
      fontVariations: [FontVariation('wght', weight.toDouble())],
      letterSpacing: trackingEm * size, // PRD tracking is em-based
      color: color,
    );
  }
}
