import 'package:flutter/material.dart';
import 'package:tumbas_servis/core/presentation/components/max_width_box.dart';
import 'package:tumbas_servis/core/presentation/components/ts_button.dart';
import 'package:tumbas_servis/core/presentation/theme/ts_theme_extension.dart';

class ConfirmBar extends StatelessWidget {
  const ConfirmBar({
    required this.totalLabel,
    required this.totalValue,
    required this.ctaLabel,
    required this.enabled,
    required this.isLoading,
    required this.onConfirm,
    super.key,
    this.loadingLabel,
    this.reasonLine,
    this.maxContentWidth,
  });

  final String totalLabel;
  final String totalValue;
  final String ctaLabel;
  final String? loadingLabel;
  final bool enabled;
  final bool isLoading;
  final VoidCallback onConfirm;
  final String? reasonLine;

  final double? maxContentWidth;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final ext = TsThemeExtension.of(context);
    final textTheme = Theme.of(context).textTheme;

    final content = Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Semantics(
            liveRegion: true,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        totalLabel,
                        style: textTheme.bodySmall?.copyWith(
                          color: ext.textMuted,
                        ),
                      ),
                      Text(
                        totalValue,
                        style: textTheme.titleMedium?.copyWith(
                          color: scheme.onSurface,
                          fontFeatures: const [FontFeature.tabularFigures()],
                        ),
                      ),
                    ],
                  ),
                ),
                if (reasonLine != null)
                  Expanded(
                    child: Text(
                      reasonLine!,
                      textAlign: TextAlign.end,
                      style: textTheme.bodySmall?.copyWith(
                        color: ext.textMuted,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          TsButton(
            label: ctaLabel,
            loadingLabel: loadingLabel,
            isLoading: isLoading,
            onPressed: (enabled && !isLoading) ? onConfirm : null,
          ),
        ],
      ),
    );

    return DecoratedBox(
      decoration: BoxDecoration(
        color: scheme.surface,
        border: Border(top: BorderSide(color: ext.borderDefault)),
      ),
      child: maxContentWidth == null
          ? content
          : MaxWidthBox(maxWidth: maxContentWidth!, child: content),
    );
  }
}
