import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:tumbas_servis/core/presentation/components/max_width_box.dart';
import 'package:tumbas_servis/core/presentation/components/ts_button.dart';
import 'package:tumbas_servis/core/presentation/theme/ts_theme_extension.dart';

class WorkshopCtaBar extends StatelessWidget {
  const WorkshopCtaBar({
    required this.ctaLabel,
    required this.onPressed,
    super.key,
    this.helperLine,
    this.isLoading = false,
    this.maxWidth,
  });

  final String ctaLabel;
  final VoidCallback? onPressed;
  final String? helperLine;
  final bool isLoading;

  final double? maxWidth;

  @override
  Widget build(BuildContext context) {
    final ext = TsThemeExtension.of(context);
    final textTheme = Theme.of(context).textTheme;

    final bar = Padding(
      padding: EdgeInsets.fromLTRB(
        16,
        8,
        16,
        8 + MediaQuery.paddingOf(context).bottom,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: ext.glassTintStrong,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: ext.glassBorder),
              boxShadow: ext.glassShadow,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (helperLine != null) ...[
                  Semantics(
                    liveRegion: true,
                    child: Text(
                      helperLine!,
                      textAlign: TextAlign.center,
                      style: textTheme.bodySmall?.copyWith(
                        color: ext.textMuted,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
                TsButton(
                  label: ctaLabel,
                  onPressed: onPressed,
                  isLoading: isLoading,
                ),
              ],
            ),
          ),
        ),
      ),
    );
    final maxWidth = this.maxWidth;
    return maxWidth == null ? bar : MaxWidthBox(maxWidth: maxWidth, child: bar);
  }
}
