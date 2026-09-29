import 'package:flutter/material.dart';
import 'package:tumbas_servis/core/presentation/components/ts_button.dart';
import 'package:tumbas_servis/core/presentation/theme/ts_theme_extension.dart';

enum CapacityBannerTone { info, warning }

class CapacityBanner extends StatelessWidget {
  const CapacityBanner({
    required this.tone,
    required this.title,
    super.key,
    this.body,
    this.actionLabel,
    this.onAction,
    this.actionLabel2,
    this.onAction2,
    this.margin = const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
  });

  final CapacityBannerTone tone;
  final String title;
  final String? body;
  final String? actionLabel;
  final VoidCallback? onAction;
  final String? actionLabel2;
  final VoidCallback? onAction2;
  final EdgeInsetsGeometry margin;

  @override
  Widget build(BuildContext context) {
    final ext = TsThemeExtension.of(context);
    final textTheme = Theme.of(context).textTheme;
    final isWarning = tone == CapacityBannerTone.warning;
    final soft = isWarning ? ext.warningSoft : ext.infoSoft;
    final text = isWarning ? ext.warningText : ext.infoText;
    final icon = isWarning
        ? Icons.error_outline_rounded
        : Icons.info_outline_rounded;

    return Semantics(
      liveRegion: true,
      child: Container(
        margin: margin,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: soft,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 20, color: text),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: textTheme.labelLarge?.copyWith(color: text),
                  ),
                  if (body != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        body!,
                        style: textTheme.bodySmall?.copyWith(color: text),
                      ),
                    ),
                  if (actionLabel != null && onAction != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Wrap(
                        spacing: 8,
                        children: [
                          TsButton(
                            label: actionLabel!,
                            onPressed: onAction,
                            type: TsButtonType.ghost,
                            compact: true,
                            fullWidth: false,
                          ),
                          if (actionLabel2 != null && onAction2 != null)
                            TsButton(
                              label: actionLabel2!,
                              onPressed: onAction2,
                              type: TsButtonType.ghost,
                              compact: true,
                              fullWidth: false,
                            ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
