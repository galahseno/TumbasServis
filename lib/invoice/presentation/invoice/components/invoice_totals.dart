import 'package:flutter/material.dart';
import 'package:tumbas_servis/core/presentation/theme/ts_theme_extension.dart';
import 'package:tumbas_servis/core/presentation/utils/currency_formatter.dart';
import 'package:tumbas_servis/invoice/presentation/invoice/components/payment_status_tag.dart';

class InvoiceTotals extends StatelessWidget {
  const InvoiceTotals({
    required this.subtotal,
    required this.discount,
    required this.total,
    required this.paid,
    super.key,
    this.voucherCode,
  });

  final int subtotal;
  final int discount;
  final int total;
  final bool paid;
  final String? voucherCode;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final ext = TsThemeExtension.of(context);
    final textTheme = Theme.of(context).textTheme;
    const figures = [FontFeature.tabularFigures()];

    Widget row(String label, String value, {Color? valueColor}) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: textTheme.bodyMedium?.copyWith(color: ext.textBody),
            ),
          ),
          Text(
            value,
            style: textTheme.bodyMedium?.copyWith(
              color: valueColor ?? ext.textBody,
              fontFeatures: figures,
            ),
          ),
        ],
      ),
    );

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          row('Subtotal', CurrencyFormatter.format(subtotal)),
          if (discount > 0)
            row(
              voucherCode == null ? 'Diskon' : 'Voucher $voucherCode',
              '−${CurrencyFormatter.format(discount)}',
              valueColor: ext.successText,
            ),
          const SizedBox(height: 4),
          Divider(height: 1, color: ext.borderDefault),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Text(
                  paid ? 'Total dibayar' : 'Total tagihan',
                  style: textTheme.titleSmall?.copyWith(
                    color: scheme.onSurface,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                CurrencyFormatter.format(total),
                style: textTheme.titleMedium?.copyWith(
                  color: scheme.onSurface,
                  fontFeatures: figures,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerLeft,
            child: PaymentStatusTag(paid: paid),
          ),
        ],
      ),
    );
  }
}
