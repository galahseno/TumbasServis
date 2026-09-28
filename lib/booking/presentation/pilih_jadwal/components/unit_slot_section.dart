import 'package:flutter/material.dart';
import 'package:tumbas_servis/core/presentation/theme/ts_theme_extension.dart';

class UnitSlotSection extends StatelessWidget {
  const UnitSlotSection({
    required this.nickname,
    required this.plateNumber,
    required this.complete,
    required this.statusLabel,
    required this.expanded,
    required this.onHeaderTap,
    required this.body,
    super.key,
  });

  final String nickname;
  final String plateNumber;
  final bool complete;
  final String statusLabel;
  final bool expanded;
  final VoidCallback onHeaderTap;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final ext = TsThemeExtension.of(context);
    final textTheme = Theme.of(context).textTheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        border: Border.all(color: ext.borderDefault),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Semantics(
            button: true,
            expanded: expanded,
            label: '$nickname $plateNumber, $statusLabel',
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onHeaderTap,
                borderRadius: BorderRadius.circular(16),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        complete
                            ? Icons.check_circle_rounded
                            : Icons.radio_button_unchecked_rounded,
                        color: complete ? ext.success : ext.textFaint,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '$nickname · $plateNumber',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: textTheme.titleSmall?.copyWith(
                                color: scheme.onSurface,
                              ),
                            ),
                            Text(
                              statusLabel,
                              style: textTheme.bodySmall?.copyWith(
                                color: ext.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        expanded
                            ? Icons.expand_less_rounded
                            : Icons.expand_more_rounded,
                        color: ext.textMuted,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (expanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: body,
            ),
        ],
      ),
    );
  }
}
