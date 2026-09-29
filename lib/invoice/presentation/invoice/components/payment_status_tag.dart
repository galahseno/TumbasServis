import 'package:flutter/material.dart';
import 'package:tumbas_servis/core/presentation/theme/ts_theme_extension.dart';

class PaymentStatusTag extends StatelessWidget {
  const PaymentStatusTag({required this.paid, super.key});

  final bool paid;

  @override
  Widget build(BuildContext context) {
    final ext = TsThemeExtension.of(context);
    final textTheme = Theme.of(context).textTheme;
    final background = paid ? ext.successSoft : ext.warningSoft;
    final foreground = paid ? ext.successText : ext.warningText;
    final icon = paid ? Icons.check_circle_rounded : Icons.schedule_rounded;
    final label = paid ? 'Lunas' : 'Belum dibayar';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ExcludeSemantics(child: Icon(icon, size: 16, color: foreground)),
          const SizedBox(width: 4),
          Text(
            label,
            style: textTheme.labelMedium?.copyWith(color: foreground),
          ),
        ],
      ),
    );
  }
}
