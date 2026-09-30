import 'package:flutter/material.dart';
import 'package:tumbas_servis/core/presentation/components/ts_button.dart';
import 'package:tumbas_servis/core/presentation/theme/ts_theme_extension.dart';
import 'package:tumbas_servis/core/presentation/utils/currency_formatter.dart';
import 'package:tumbas_servis/invoice/presentation/invoice/components/payment_status_tag.dart';

class InvoiceSummaryCard extends StatelessWidget {
  const InvoiceSummaryCard({
    required this.paid,
    required this.subtotal,
    required this.discount,
    required this.total,
    required this.workshopName,
    required this.issuedLine,
    required this.ctaLabel,
    required this.isLoading,
    required this.onCta,
    super.key,
    this.voucherCode,
  });

  final bool paid;
  final int subtotal;
  final int discount;
  final int total;
  final String workshopName;
  final String issuedLine;
  final String? voucherCode;
  final String ctaLabel;
  final bool isLoading;
  final VoidCallback onCta;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final ext = TsThemeExtension.of(context);
    final textTheme = Theme.of(context).textTheme;
    const figures = [FontFeature.tabularFigures()];

    Widget line(String label, String value, {Color? color}) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: textTheme.bodyMedium?.copyWith(color: ext.textBody),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            value,
            style: textTheme.bodyMedium?.copyWith(
              color: color ?? ext.textBody,
              fontFeatures: figures,
            ),
          ),
        ],
      ),
    );

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: scheme.surfaceContainer,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: ext.borderDefault),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            paid ? 'Total dibayar' : 'Total tagihan',
            style: textTheme.labelLarge?.copyWith(color: ext.textMuted),
          ),
          const SizedBox(height: 4),
          Text(
            CurrencyFormatter.format(total),
            style: textTheme.headlineSmall?.copyWith(
              color: scheme.onSurface,
              fontFeatures: figures,
            ),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerLeft,
            child: PaymentStatusTag(paid: paid),
          ),
          const SizedBox(height: 16),
          Divider(height: 1, color: ext.borderDefault),
          const SizedBox(height: 12),
          line('Subtotal', CurrencyFormatter.format(subtotal)),
          if (discount > 0)
            line(
              voucherCode == null ? 'Diskon' : 'Voucher $voucherCode',
              '−${CurrencyFormatter.format(discount)}',
              color: ext.successText,
            ),
          const SizedBox(height: 12),
          Divider(height: 1, color: ext.borderDefault),
          const SizedBox(height: 12),
          Text(
            workshopName,
            style: textTheme.titleSmall?.copyWith(color: scheme.onSurface),
          ),
          Text(
            issuedLine,
            style: textTheme.bodySmall?.copyWith(color: ext.textMuted),
          ),
          const SizedBox(height: 20),
          TsButton(label: ctaLabel, isLoading: isLoading, onPressed: onCta),
          const SizedBox(height: 12),
          Row(
            children: [
              ExcludeSemantics(
                child: Icon(
                  Icons.payments_outlined,
                  size: 18,
                  color: ext.textMuted,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  paid ? 'Dibayar di bengkel' : 'Bayar di bengkel',
                  style: textTheme.bodySmall?.copyWith(color: ext.textMuted),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
