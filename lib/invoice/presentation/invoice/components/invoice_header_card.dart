import 'package:flutter/material.dart';
import 'package:tumbas_servis/core/presentation/theme/ts_theme_extension.dart';
import 'package:tumbas_servis/invoice/presentation/invoice/components/payment_status_tag.dart';

class InvoiceHeaderCard extends StatelessWidget {
  const InvoiceHeaderCard({
    required this.bookingCode,
    required this.issuedLine,
    required this.paid,
    required this.workshopName,
    required this.workshopAddress,
    super.key,
  });

  final String bookingCode;
  final String issuedLine;
  final bool paid;
  final String workshopName;
  final String workshopAddress;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final ext = TsThemeExtension.of(context);
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Invoice',
                      style: textTheme.labelSmall?.copyWith(
                        color: ext.textMuted,
                      ),
                    ),
                    Text(
                      bookingCode,
                      style: textTheme.titleMedium?.copyWith(
                        color: scheme.onSurface,
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      issuedLine,
                      style: textTheme.bodySmall?.copyWith(
                        color: ext.textMuted,
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              PaymentStatusTag(paid: paid),
            ],
          ),
          const SizedBox(height: 12),
          Divider(height: 1, color: ext.borderDefault),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ExcludeSemantics(
                child: Icon(
                  Icons.build_circle_outlined,
                  size: 20,
                  color: ext.textMuted,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      workshopName,
                      style: textTheme.titleSmall?.copyWith(
                        color: scheme.onSurface,
                      ),
                    ),
                    Text(
                      workshopAddress,
                      style: textTheme.bodySmall?.copyWith(
                        color: ext.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
