import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:tumbas_servis/core/presentation/components/ts_button.dart';
import 'package:tumbas_servis/core/presentation/theme/ts_theme_extension.dart';

class StickyEstimateBar extends StatelessWidget {
  const StickyEstimateBar({
    required this.durationLabel,
    required this.totalLabel,
    required this.onContinue,
    super.key,
    this.reasonLine,
  });

  final String durationLabel;
  final String totalLabel;
  final String? reasonLine;
  final VoidCallback? onContinue;

  @override
  Widget build(BuildContext context) {
    final ext = TsThemeExtension.of(context);
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
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
            child: Row(
              children: [
                Expanded(
                  child: Semantics(
                    liveRegion: true,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          durationLabel,
                          style: textTheme.bodySmall?.copyWith(
                            color: ext.textMuted,
                          ),
                        ),
                        Text(
                          totalLabel,
                          style: textTheme.titleMedium?.copyWith(
                            color: scheme.onSurface,
                          ),
                        ),
                        if (reasonLine != null)
                          Text(
                            reasonLine!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: textTheme.bodySmall?.copyWith(
                              color: ext.dangerText,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  width: 120,
                  child: TsButton(
                    label: 'Lanjut',
                    fullWidth: false,
                    onPressed: onContinue,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
