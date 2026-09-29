import 'package:flutter/material.dart';
import 'package:tumbas_servis/core/presentation/theme/ts_theme_extension.dart';

class PaymentNote extends StatelessWidget {
  const PaymentNote({super.key});

  @override
  Widget build(BuildContext context) {
    final ext = TsThemeExtension.of(context);
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        children: [
          Icon(Icons.payments_outlined, size: 18, color: ext.textMuted),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Bayar di bengkel saat selesai',
              style: textTheme.bodySmall?.copyWith(color: ext.textMuted),
            ),
          ),
        ],
      ),
    );
  }
}
