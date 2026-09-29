import 'package:flutter/material.dart';
import 'package:tumbas_servis/core/domain/model/invoice/invoice_line.dart';
import 'package:tumbas_servis/core/presentation/theme/ts_theme_extension.dart';
import 'package:tumbas_servis/core/presentation/utils/currency_formatter.dart';

class PriceBreakdownInvoice extends StatelessWidget {
  const PriceBreakdownInvoice({
    required this.unitTitle,
    required this.lines,
    super.key,
  });

  final String unitTitle;
  final List<InvoiceLine> lines;

  int get unitTotal => lines.fold<int>(0, (sum, l) => sum + l.qty * l.price);

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final ext = TsThemeExtension.of(context);
    final textTheme = Theme.of(context).textTheme;
    const figures = [FontFeature.tabularFigures()];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: ext.borderDefault),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            unitTitle,
            style: textTheme.titleSmall?.copyWith(color: scheme.onSurface),
          ),
          const SizedBox(height: 8),
          for (final line in lines)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      line.qty > 1 ? '${line.label} × ${line.qty}' : line.label,
                      style: textTheme.bodyMedium?.copyWith(
                        color: ext.textBody,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    CurrencyFormatter.format(line.qty * line.price),
                    style: textTheme.bodyMedium?.copyWith(
                      color: ext.textBody,
                      fontFeatures: figures,
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 4),
          Divider(height: 1, color: ext.borderDefault),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Subtotal unit',
                  style: textTheme.labelLarge?.copyWith(color: ext.textBody),
                ),
              ),
              Text(
                CurrencyFormatter.format(unitTotal),
                style: textTheme.labelLarge?.copyWith(
                  color: scheme.onSurface,
                  fontFeatures: figures,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
