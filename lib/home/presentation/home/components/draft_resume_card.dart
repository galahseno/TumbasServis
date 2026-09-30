import 'package:flutter/material.dart';
import 'package:tumbas_servis/core/presentation/components/ts_button.dart';
import 'package:tumbas_servis/core/presentation/theme/ts_theme_extension.dart';
import 'package:tumbas_servis/home/presentation/home/state/home_state.dart';

class DraftResumeCard extends StatelessWidget {
  const DraftResumeCard({
    required this.display,
    super.key,
    this.onResume,
    this.onDelete,
  });

  final HomeDraftDisplay display;
  final VoidCallback? onResume;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final ext = TsThemeExtension.of(context);
    final textTheme = Theme.of(context).textTheme;
    final expiryColor = display.expiringSoon ? ext.warningText : ext.textMuted;

    return InkWell(
      onTap: onResume,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: scheme.surfaceContainer,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: ext.borderDefault),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: scheme.primaryContainer,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.edit_note_rounded,
                    color: scheme.onPrimaryContainer,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Lanjutkan booking',
                        style: textTheme.titleSmall?.copyWith(
                          color: scheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        display.summaryLine,
                        style: textTheme.bodySmall?.copyWith(
                          color: ext.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  display.expiringSoon
                      ? Icons.schedule_rounded
                      : Icons.access_time_rounded,
                  size: 16,
                  color: expiryColor,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    display.expiryLabel,
                    style: textTheme.bodySmall?.copyWith(color: expiryColor),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: Wrap(
                alignment: WrapAlignment.end,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 8,
                runSpacing: 4,
                children: [
                  IntrinsicWidth(
                    child: TsButton(
                      label: 'Hapus draft',
                      onPressed: onDelete,
                      type: TsButtonType.ghost,
                      compact: true,
                      fullWidth: false,
                    ),
                  ),
                  IntrinsicWidth(
                    child: TsButton(
                      label: 'Lanjutkan',
                      onPressed: onResume,
                      type: TsButtonType.secondary,
                      compact: true,
                      fullWidth: false,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
