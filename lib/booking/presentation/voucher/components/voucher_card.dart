import 'package:flutter/material.dart';
import 'package:tumbas_servis/core/presentation/theme/ts_theme_extension.dart';

class VoucherCard extends StatelessWidget {
  const VoucherCard({
    required this.title,
    required this.subtitle,
    required this.selected,
    super.key,
    this.savingLabel,
    this.reasonLabel,
    this.enabled = true,
    this.onTap,
  });

  final String title;
  final String subtitle;
  final bool selected;
  final String? savingLabel;
  final String? reasonLabel;
  final bool enabled;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final ext = TsThemeExtension.of(context);
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final semanticsLabel = enabled
        ? [
            title,
            if (savingLabel != null) savingLabel,
            if (selected) 'terpilih',
          ].join(', ')
        : '$title tidak bisa dipakai, ${reasonLabel ?? ''}';

    return Semantics(
      button: true,
      selected: selected,
      enabled: enabled,
      label: semanticsLabel,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: enabled ? onTap : null,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(
                color: selected ? ext.borderAccent : ext.borderDefault,
                width: selected ? 2 : 1,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ExcludeSemantics(
                  child: Icon(
                    selected
                        ? Icons.radio_button_checked_rounded
                        : Icons.radio_button_unchecked_rounded,
                    color: !enabled
                        ? ext.textFaint
                        : selected
                        ? ext.accent
                        : ext.textMuted,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ExcludeSemantics(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          title,
                          style: textTheme.bodyMedium?.copyWith(
                            color: enabled ? scheme.onSurface : ext.textFaint,
                          ),
                        ),
                        Text(
                          subtitle,
                          style: textTheme.bodySmall?.copyWith(
                            color: ext.textMuted,
                          ),
                        ),
                        if (enabled && savingLabel != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              savingLabel!,
                              style: textTheme.bodySmall?.copyWith(
                                color: ext.successText,
                              ),
                            ),
                          ),
                        if (!enabled && reasonLabel != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: ext.warningSoft,
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Text(
                                reasonLabel!,
                                style: textTheme.labelSmall?.copyWith(
                                  color: ext.warningText,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
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
