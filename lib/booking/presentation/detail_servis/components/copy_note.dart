import 'package:flutter/material.dart';
import 'package:tumbas_servis/core/presentation/theme/ts_theme_extension.dart';

class CopyNote extends StatelessWidget {
  const CopyNote({required this.droppedCount, super.key});

  final int droppedCount;

  @override
  Widget build(BuildContext context) {
    final ext = TsThemeExtension.of(context);
    final textTheme = Theme.of(context).textTheme;

    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: ext.warningSoft,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_rounded, size: 16, color: ext.warning),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '$droppedCount item suku cadang tidak disalin karena tidak '
              'kompatibel',
              style: textTheme.bodySmall?.copyWith(color: ext.warningText),
            ),
          ),
        ],
      ),
    );
  }
}
