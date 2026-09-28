import 'package:flutter/material.dart';

@immutable
class TsThemeExtension extends ThemeExtension<TsThemeExtension> {
  const TsThemeExtension({
    required this.textBody,
    required this.textMuted,
    required this.textFaint,
    required this.textAccent,
    required this.accent,
    required this.accentHover,
    required this.accentPressed,
    required this.borderDefault,
    required this.borderStrong,
    required this.borderAccent,
    required this.focusRing,
    required this.success,
    required this.successText,
    required this.successSoft,
    required this.warning,
    required this.warningText,
    required this.warningSoft,
    required this.info,
    required this.infoText,
    required this.infoSoft,
    required this.danger,
    required this.dangerText,
    required this.dangerSoft,
    required this.dangerPressed,
    required this.ratingStar,
    required this.textOnInverse,
    required this.accentOnInverse,
    required this.skeletonBase,
    required this.skeletonHighlight,
    required this.illustrationOutline,
    required this.statePressed,
    required this.bgPageClear,
    required this.scrim,
    required this.glassTint,
    required this.glassTintStrong,
    required this.glassBorder,
    required this.glassSheenTop,
    required this.glassSheenBottom,
    required this.shadowSm,
    required this.shadowMd,
    required this.shadowAccent,
    required this.glassShadow,
  });

  final Color textBody;
  final Color textMuted;
  final Color textFaint;
  final Color textAccent;

  final Color accent;
  final Color accentHover;
  final Color accentPressed;

  final Color borderDefault;
  final Color borderStrong;
  final Color borderAccent;

  final Color focusRing;

  final Color success;
  final Color successText;
  final Color successSoft;
  final Color warning;
  final Color warningText;
  final Color warningSoft;
  final Color info;
  final Color infoText;
  final Color infoSoft;
  final Color danger;
  final Color dangerText;
  final Color dangerSoft;
  final Color dangerPressed;
  final Color ratingStar;

  final Color textOnInverse;
  final Color accentOnInverse;

  final Color skeletonBase;
  final Color skeletonHighlight;
  final Color illustrationOutline;
  final Color statePressed;
  final Color bgPageClear;
  final Color scrim;

  final Color glassTint;
  final Color glassTintStrong;
  final Color glassBorder;
  final Color glassSheenTop;
  final Color glassSheenBottom;

  final List<BoxShadow> shadowSm;
  final List<BoxShadow> shadowMd;
  final List<BoxShadow> shadowAccent;
  final List<BoxShadow> glassShadow;

  static TsThemeExtension of(BuildContext context) =>
      Theme.of(context).extension<TsThemeExtension>()!;

  @override
  TsThemeExtension copyWith({
    Color? textBody,
    Color? textMuted,
    Color? textFaint,
    Color? textAccent,
    Color? accent,
    Color? accentHover,
    Color? accentPressed,
    Color? borderDefault,
    Color? borderStrong,
    Color? borderAccent,
    Color? focusRing,
    Color? success,
    Color? successText,
    Color? successSoft,
    Color? warning,
    Color? warningText,
    Color? warningSoft,
    Color? info,
    Color? infoText,
    Color? infoSoft,
    Color? danger,
    Color? dangerText,
    Color? dangerSoft,
    Color? dangerPressed,
    Color? ratingStar,
    Color? textOnInverse,
    Color? accentOnInverse,
    Color? skeletonBase,
    Color? skeletonHighlight,
    Color? illustrationOutline,
    Color? statePressed,
    Color? bgPageClear,
    Color? scrim,
    Color? glassTint,
    Color? glassTintStrong,
    Color? glassBorder,
    Color? glassSheenTop,
    Color? glassSheenBottom,
    List<BoxShadow>? shadowSm,
    List<BoxShadow>? shadowMd,
    List<BoxShadow>? shadowAccent,
    List<BoxShadow>? glassShadow,
  }) {
    return TsThemeExtension(
      textBody: textBody ?? this.textBody,
      textMuted: textMuted ?? this.textMuted,
      textFaint: textFaint ?? this.textFaint,
      textAccent: textAccent ?? this.textAccent,
      accent: accent ?? this.accent,
      accentHover: accentHover ?? this.accentHover,
      accentPressed: accentPressed ?? this.accentPressed,
      borderDefault: borderDefault ?? this.borderDefault,
      borderStrong: borderStrong ?? this.borderStrong,
      borderAccent: borderAccent ?? this.borderAccent,
      focusRing: focusRing ?? this.focusRing,
      success: success ?? this.success,
      successText: successText ?? this.successText,
      successSoft: successSoft ?? this.successSoft,
      warning: warning ?? this.warning,
      warningText: warningText ?? this.warningText,
      warningSoft: warningSoft ?? this.warningSoft,
      info: info ?? this.info,
      infoText: infoText ?? this.infoText,
      infoSoft: infoSoft ?? this.infoSoft,
      danger: danger ?? this.danger,
      dangerText: dangerText ?? this.dangerText,
      dangerSoft: dangerSoft ?? this.dangerSoft,
      dangerPressed: dangerPressed ?? this.dangerPressed,
      ratingStar: ratingStar ?? this.ratingStar,
      textOnInverse: textOnInverse ?? this.textOnInverse,
      accentOnInverse: accentOnInverse ?? this.accentOnInverse,
      skeletonBase: skeletonBase ?? this.skeletonBase,
      skeletonHighlight: skeletonHighlight ?? this.skeletonHighlight,
      illustrationOutline: illustrationOutline ?? this.illustrationOutline,
      statePressed: statePressed ?? this.statePressed,
      bgPageClear: bgPageClear ?? this.bgPageClear,
      scrim: scrim ?? this.scrim,
      glassTint: glassTint ?? this.glassTint,
      glassTintStrong: glassTintStrong ?? this.glassTintStrong,
      glassBorder: glassBorder ?? this.glassBorder,
      glassSheenTop: glassSheenTop ?? this.glassSheenTop,
      glassSheenBottom: glassSheenBottom ?? this.glassSheenBottom,
      shadowSm: shadowSm ?? this.shadowSm,
      shadowMd: shadowMd ?? this.shadowMd,
      shadowAccent: shadowAccent ?? this.shadowAccent,
      glassShadow: glassShadow ?? this.glassShadow,
    );
  }

  @override
  TsThemeExtension lerp(ThemeExtension<TsThemeExtension>? other, double t) {
    if (other is! TsThemeExtension) return this;
    return t < 0.5 ? this : other;
  }
}
