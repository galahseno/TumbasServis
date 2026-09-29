import 'package:flutter/material.dart';
import 'package:tumbas_servis/core/presentation/theme/ts_theme_extension.dart';

class WorkshopPhoto extends StatelessWidget {
  const WorkshopPhoto({this.height, super.key});

  final double? height;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final ext = TsThemeExtension.of(context);

    final photo = Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [scheme.primaryContainer, scheme.surfaceContainerHighest],
        ),
      ),
      alignment: Alignment.center,
      child: Icon(Icons.storefront_rounded, size: 56, color: ext.accent),
    );
    final height = this.height;
    return height == null
        ? AspectRatio(aspectRatio: 16 / 9, child: photo)
        : SizedBox(height: height, width: double.infinity, child: photo);
  }
}
