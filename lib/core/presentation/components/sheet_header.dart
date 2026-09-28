import 'package:flutter/material.dart';
import 'package:tumbas_servis/core/presentation/components/ts_icon_button.dart';
import 'package:tumbas_servis/core/presentation/theme/ts_theme_extension.dart';

class SheetHeader extends StatelessWidget {
  const SheetHeader({
    required this.title,
    super.key,
    this.subtitle,
    this.onClose,
  });

  final String title;
  final String? subtitle;
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    final ext = TsThemeExtension.of(context);
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          child: Container(
            width: 32,
            height: 4,
            margin: const EdgeInsets.only(top: 12, bottom: 12),
            decoration: BoxDecoration(
              color: ext.borderStrong,
              borderRadius: BorderRadius.circular(999),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: textTheme.titleMedium?.copyWith(
                        color: scheme.onSurface,
                      ),
                    ),
                    if (subtitle != null)
                      Text(
                        subtitle!,
                        style: textTheme.bodySmall?.copyWith(
                          color: ext.textMuted,
                        ),
                      ),
                  ],
                ),
              ),
              if (onClose != null)
                TsIconButton(
                  icon: Icons.close_rounded,
                  onPressed: onClose,
                  semanticLabel: 'Tutup',
                ),
            ],
          ),
        ),
      ],
    );
  }
}
