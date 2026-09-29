import 'package:flutter/material.dart';
import 'package:tumbas_servis/core/presentation/theme/ts_theme_extension.dart';

class ErrorSimBanner extends StatelessWidget {
  const ErrorSimBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final ext = TsThemeExtension.of(context);
    final textTheme = Theme.of(context).textTheme;

    return Semantics(
      liveRegion: true,
      container: true,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: ext.warningSoft,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(Icons.warning_amber_rounded, size: 20, color: ext.warningText),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Aksi berikutnya akan gagal',
                style: textTheme.bodyMedium?.copyWith(color: ext.warningText),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
