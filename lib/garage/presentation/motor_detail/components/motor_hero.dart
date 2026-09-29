import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tumbas_servis/core/domain/model/booking/unit_status.dart';
import 'package:tumbas_servis/core/domain/model/garage/motor.dart';
import 'package:tumbas_servis/core/domain/model/garage/motor_model.dart';
import 'package:tumbas_servis/core/presentation/components/unit_status_badge.dart';
import 'package:tumbas_servis/core/presentation/theme/ts_theme_extension.dart';
import 'package:tumbas_servis/garage/presentation/utils/motor_display.dart';

class MotorHero extends StatelessWidget {
  const MotorHero({
    required this.motor,
    required this.model,
    super.key,
    this.inServiceStatus,
  });

  final Motor motor;
  final MotorModel? model;
  final UnitStatus? inServiceStatus;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final ext = TsThemeExtension.of(context);
    final textTheme = Theme.of(context).textTheme;

    final silhouette = Container(
      width: 96,
      height: 96,
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
      ),
      alignment: Alignment.center,
      child: Icon(Icons.two_wheeler_rounded, size: 56, color: ext.textFaint),
    );
    final caption = [
      if (model != null) modelDisplayName(model!),
      if (model != null) motorCategoryLabel(model!.category),
      if (motor.year != null) '${motor.year}',
    ].join(' · ');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ExcludeSemantics(
          child: Container(
            height: 168,
            width: double.infinity,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: scheme.primaryContainer,
              borderRadius: BorderRadius.circular(24),
            ),
            alignment: Alignment.center,
            child: motor.photoUrl == null
                ? silhouette
                : Image.file(
                    File(motor.photoUrl!),
                    width: double.infinity,
                    height: 168,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => silhouette,
                  ),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          motor.nickname,
          style: textTheme.headlineMedium?.copyWith(color: scheme.onSurface),
        ),
        const SizedBox(height: 4),
        Text(
          motor.plateNumber,
          style: textTheme.titleLarge?.copyWith(color: ext.textBody),
        ),
        if (caption.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            caption,
            style: textTheme.bodyLarge?.copyWith(color: ext.textMuted),
          ),
        ],
        if (inServiceStatus != null) ...[
          const SizedBox(height: 12),
          UnitStatusBadge(status: inServiceStatus!),
        ],
      ],
    );
  }
}
