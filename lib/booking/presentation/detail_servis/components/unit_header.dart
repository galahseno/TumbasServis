import 'package:flutter/material.dart';
import 'package:tumbas_servis/core/presentation/components/ts_dialog.dart';
import 'package:tumbas_servis/core/presentation/components/ts_icon_button.dart';

class UnitHeader extends StatelessWidget {
  const UnitHeader({
    required this.nickname,
    required this.plateNumber,
    required this.showRemove,
    required this.hasSelections,
    required this.onRemove,
    super.key,
  });

  final String nickname;
  final String plateNumber;
  final bool showRemove;
  final bool hasSelections;
  final VoidCallback onRemove;

  Future<void> _handleRemove(BuildContext context) async {
    if (!hasSelections) {
      onRemove();
      return;
    }
    final confirmed = await TsDialog.confirmDestructive(
      context,
      title: 'Keluarkan $nickname dari booking?',
      message: 'Pilihan servis dan suku cadang untuk motor ini akan dihapus.',
      confirmLabel: 'Keluarkan',
    );
    if (confirmed ?? false) onRemove();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        Expanded(
          child: Text(
            'Untuk: $nickname · $plateNumber',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textTheme.titleMedium?.copyWith(color: scheme.onSurface),
          ),
        ),
        if (showRemove)
          TsIconButton(
            icon: Icons.do_not_disturb_on_rounded,
            onPressed: () => _handleRemove(context),
            semanticLabel: 'Keluarkan $nickname dari booking',
          ),
      ],
    );
  }
}
