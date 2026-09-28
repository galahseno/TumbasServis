import 'package:flutter/material.dart';
import 'package:tumbas_servis/core/presentation/theme/ts_theme_extension.dart';

class MotorSelectCard extends StatelessWidget {
  const MotorSelectCard({
    required this.nickname,
    required this.plateNumber,
    required this.selected,
    required this.semanticLabel,
    super.key,
    this.disabledReason,
    this.onTap,
  });

  final String nickname;
  final String plateNumber;
  final bool selected;
  final String? disabledReason;
  final String semanticLabel;
  final VoidCallback? onTap;

  bool get _disabled => disabledReason != null && !selected;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final ext = TsThemeExtension.of(context);
    final textTheme = Theme.of(context).textTheme;

    return Semantics(
      button: true,
      enabled: !_disabled,
      selected: selected,
      label: semanticLabel,
      child: Opacity(
        opacity: _disabled ? 0.6 : 1,
        child: InkWell(
          onTap: _disabled ? null : onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(12),
            constraints: const BoxConstraints(minHeight: 48),
            decoration: BoxDecoration(
              color: scheme.surfaceContainer,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: selected ? ext.borderAccent : ext.borderDefault,
                width: selected ? 2 : 1,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: scheme.surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.two_wheeler_rounded,
                    size: 28,
                    color: ext.textFaint,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        nickname,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.labelLarge?.copyWith(
                          color: scheme.onSurface,
                        ),
                      ),
                      Text(
                        plateNumber,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.bodySmall?.copyWith(
                          color: ext.textMuted,
                        ),
                      ),
                      if (_disabled) ...[
                        const SizedBox(height: 6),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.block_rounded,
                              size: 14,
                              color: ext.textMuted,
                            ),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                disabledReason!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: textTheme.labelSmall?.copyWith(
                                  color: ext.textMuted,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  selected
                      ? Icons.check_circle_rounded
                      : Icons.radio_button_unchecked_rounded,
                  color: selected ? ext.accent : ext.textFaint,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
