import 'package:flutter/material.dart';
import 'package:tumbas_servis/core/presentation/theme/ts_theme_extension.dart';

class WorkshopPhoto extends StatelessWidget {
  const WorkshopPhoto({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final ext = TsThemeExtension.of(context);

    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [scheme.primaryContainer, scheme.surfaceContainerHighest],
          ),
        ),
        alignment: Alignment.center,
        child: Icon(Icons.storefront_rounded, size: 56, color: ext.accent),
      ),
    );
  }
}
