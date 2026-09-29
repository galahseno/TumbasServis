import 'package:flutter/material.dart';
import 'package:tumbas_servis/core/presentation/components/max_width_box.dart';
import 'package:tumbas_servis/core/presentation/components/ts_button.dart';
import 'package:tumbas_servis/core/presentation/theme/ts_theme_extension.dart';

class SelectionFooter extends StatelessWidget {
  const SelectionFooter({
    required this.recapLine,
    required this.ctaLabel,
    required this.canContinue,
    required this.onContinue,
    this.reasonLine,
    this.isLoading = false,
    this.maxContentWidth,
    this.backgroundColor,
    super.key,
  });

  final String recapLine;
  final String? reasonLine;
  final String ctaLabel;
  final bool canContinue;
  final bool isLoading;
  final VoidCallback onContinue;

  final double? maxContentWidth;

  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final ext = TsThemeExtension.of(context);
    final textTheme = Theme.of(context).textTheme;

    final row = Row(
      children: [
        Expanded(
          child: Semantics(
            liveRegion: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  recapLine,
                  style: textTheme.labelLarge?.copyWith(color: ext.textBody),
                ),
                if (reasonLine != null)
                  Text(
                    reasonLine!,
                    style: textTheme.bodySmall?.copyWith(color: ext.textMuted),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: 120,
          child: TsButton(
            label: ctaLabel,
            fullWidth: false,
            onPressed: (canContinue && !isLoading) ? onContinue : null,
          ),
        ),
      ],
    );

    final padded = Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
      child: row,
    );

    return DecoratedBox(
      decoration: BoxDecoration(
        color: backgroundColor ?? scheme.surface,
        border: Border(top: BorderSide(color: ext.borderDefault)),
      ),
      child: maxContentWidth == null
          ? padded
          : MaxWidthBox(maxWidth: maxContentWidth!, child: padded),
    );
  }
}
