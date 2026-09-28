import 'package:flutter/material.dart';
import 'package:tumbas_servis/core/presentation/components/ts_button.dart';
import 'package:tumbas_servis/core/presentation/theme/ts_theme_extension.dart';
import 'package:tumbas_servis/core/presentation/utils/currency_formatter.dart';

class SelectedPartsBar extends StatelessWidget {
  const SelectedPartsBar({
    required this.selectedCount,
    required this.subtotal,
    required this.onSelesai,
    required this.isLoading,
    super.key,
  });

  final int selectedCount;
  final int subtotal;
  final VoidCallback onSelesai;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final ext = TsThemeExtension.of(context);
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
      decoration: BoxDecoration(
        color: scheme.surface,
        border: Border(top: BorderSide(color: ext.borderDefault)),
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
                    '$selectedCount dipilih',
                    style: textTheme.labelLarge?.copyWith(color: ext.textBody),
                  ),
                  Text(
                    'Subtotal ${CurrencyFormatter.format(subtotal)}',
                    style: textTheme.bodySmall?.copyWith(
                      color: ext.textMuted,
                      fontFeatures: const [FontFeature.tabularFigures()],
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
              label: 'Selesai',
              fullWidth: false,
              isLoading: isLoading,
              onPressed: isLoading ? null : onSelesai,
            ),
          ),
        ],
      ),
    );
  }
}
