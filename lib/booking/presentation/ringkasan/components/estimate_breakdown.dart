import 'package:flutter/material.dart';
import 'package:tumbas_servis/booking/presentation/ringkasan/components/price_line.dart';
import 'package:tumbas_servis/core/presentation/theme/ts_theme_extension.dart';
import 'package:tumbas_servis/core/presentation/utils/currency_formatter.dart';

class EstimateBreakdown extends StatelessWidget {
  const EstimateBreakdown({
    required this.unitLines,
    required this.subtotal,
    required this.discount,
    required this.total,
    this.voucherLabel,
    this.durationCaption = '',
    this.bordered = true,
    super.key,
  });

  final List<({String label, int subtotal})> unitLines;
  final int subtotal;
  final int discount;
  final int total;
  final String? voucherLabel;
  final String durationCaption;
  final bool bordered;

  @override
  Widget build(BuildContext context) {
    final ext = TsThemeExtension.of(context);
    final textTheme = Theme.of(context).textTheme;

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Estimasi biaya',
          style: textTheme.titleSmall?.copyWith(color: ext.textBody),
        ),
        const SizedBox(height: 8),
        for (final line in unitLines)
          PriceLine(
            label: line.label,
            value: CurrencyFormatter.format(line.subtotal),
          ),
        if (voucherLabel != null) ...[
          PriceLine(
            label: 'Subtotal',
            value: CurrencyFormatter.format(subtotal),
          ),
          PriceLine(
            label: voucherLabel!,
            value: '−${CurrencyFormatter.format(discount)}',
          ),
        ],
        const Divider(height: 20),
        PriceLine(
          label: 'Total estimasi',
          value: CurrencyFormatter.format(total),
          emphasized: true,
        ),
        if (durationCaption.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            durationCaption,
            style: textTheme.bodySmall?.copyWith(color: ext.textMuted),
          ),
        ],
      ],
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: bordered
          ? Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: ext.borderDefault),
                borderRadius: BorderRadius.circular(16),
              ),
              child: content,
            )
          : content,
    );
  }
}
