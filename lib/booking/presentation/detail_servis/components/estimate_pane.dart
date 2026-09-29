import 'package:flutter/material.dart';
import 'package:tumbas_servis/core/presentation/components/ts_button.dart';
import 'package:tumbas_servis/core/presentation/theme/ts_theme_extension.dart';
import 'package:tumbas_servis/core/presentation/utils/currency_formatter.dart';

class EstimatePaneLine {
  const EstimatePaneLine({required this.label, this.subtotal});

  final String label;

  final int? subtotal;
}

class EstimatePane extends StatelessWidget {
  const EstimatePane({
    required this.lines,
    required this.totalLabel,
    required this.durationLabel,
    required this.onContinue,
    this.reasonLine,
    super.key,
  });

  final List<EstimatePaneLine> lines;
  final String totalLabel;
  final String durationLabel;
  final String? reasonLine;
  final VoidCallback? onContinue;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final ext = TsThemeExtension.of(context);
    final textTheme = Theme.of(context).textTheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: scheme.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ext.borderDefault),
        boxShadow: ext.glassShadow,
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Estimasi biaya',
              style: textTheme.titleSmall?.copyWith(color: ext.textBody),
            ),
            const SizedBox(height: 12),
            for (final line in lines)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        line.label,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.bodyMedium?.copyWith(
                          color: ext.textBody,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      line.subtotal == null
                          ? 'Belum dipilih'
                          : CurrencyFormatter.format(line.subtotal!),
                      style: textTheme.bodyMedium?.copyWith(
                        color: line.subtotal == null
                            ? ext.textFaint
                            : ext.textBody,
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
                    ),
                  ],
                ),
              ),
            const Divider(height: 24),
            Semantics(
              liveRegion: true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Total estimasi',
                          style: textTheme.titleSmall?.copyWith(
                            color: scheme.onSurface,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        totalLabel,
                        style: textTheme.titleMedium?.copyWith(
                          color: scheme.onSurface,
                          fontFeatures: const [FontFeature.tabularFigures()],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    durationLabel,
                    style: textTheme.bodySmall?.copyWith(color: ext.textMuted),
                  ),
                  if (reasonLine != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      reasonLine!,
                      style: textTheme.bodySmall?.copyWith(
                        color: ext.dangerText,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 16),
            TsButton(label: 'Lanjut', onPressed: onContinue),
          ],
        ),
      ),
    );
  }
}
