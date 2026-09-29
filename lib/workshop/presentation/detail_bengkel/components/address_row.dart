import 'package:flutter/material.dart';
import 'package:tumbas_servis/core/presentation/components/ts_button.dart';
import 'package:tumbas_servis/core/presentation/theme/ts_theme_extension.dart';

class AddressRow extends StatelessWidget {
  const AddressRow({
    required this.address,
    required this.onCopy,
    required this.onOpenMaps,
    super.key,
  });

  final String address;
  final VoidCallback onCopy;
  final VoidCallback onOpenMaps;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final ext = TsThemeExtension.of(context);
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.place_outlined, size: 20, color: ext.textMuted),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                address,
                style: textTheme.bodyMedium?.copyWith(color: scheme.onSurface),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            TsButton(
              label: 'Salin',
              type: TsButtonType.outline,
              compact: true,
              fullWidth: false,
              leadingIcon: Icons.copy_rounded,
              onPressed: onCopy,
            ),
            TsButton(
              label: 'Buka di Maps',
              type: TsButtonType.outline,
              compact: true,
              fullWidth: false,
              leadingIcon: Icons.map_outlined,
              onPressed: onOpenMaps,
            ),
          ],
        ),
      ],
    );
  }
}
