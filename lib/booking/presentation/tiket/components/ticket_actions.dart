import 'package:flutter/material.dart';
import 'package:tumbas_servis/core/presentation/components/ts_button.dart';
import 'package:tumbas_servis/core/presentation/theme/ts_theme_extension.dart';

class TicketActions extends StatelessWidget {
  const TicketActions({
    required this.trackEnabled,
    required this.onTrack,
    required this.onHome,
    super.key,
  });

  final bool trackEnabled;
  final VoidCallback onTrack;
  final VoidCallback onHome;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final ext = TsThemeExtension.of(context);
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
      decoration: BoxDecoration(
        color: scheme.surface,
        border: Border(top: BorderSide(color: ext.borderDefault)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TsButton(
            label: 'Lacak status',
            onPressed: trackEnabled ? onTrack : null,
          ),
          if (!trackEnabled) ...[
            const SizedBox(height: 4),
            Text(
              'Aktif setelah tiket dibuat',
              textAlign: TextAlign.center,
              style: textTheme.bodySmall?.copyWith(color: ext.textMuted),
            ),
          ],
          const SizedBox(height: 8),
          TsButton(
            label: 'Kembali ke beranda',
            type: TsButtonType.secondary,
            onPressed: onHome,
          ),
        ],
      ),
    );
  }
}
