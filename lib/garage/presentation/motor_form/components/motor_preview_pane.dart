import 'package:flutter/material.dart';
import 'package:tumbas_servis/core/domain/model/garage/motor_model.dart';
import 'package:tumbas_servis/core/presentation/components/vehicle_select_card.dart';
import 'package:tumbas_servis/core/presentation/theme/ts_theme_extension.dart';
import 'package:tumbas_servis/garage/presentation/utils/motor_display.dart';

class MotorPreviewPane extends StatelessWidget {
  const MotorPreviewPane({
    required this.nickname,
    required this.plateNumber,
    required this.model,
    super.key,
  });

  final String nickname;
  final String plateNumber;
  final MotorModel? model;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final ext = TsThemeExtension.of(context);
    final textTheme = Theme.of(context).textTheme;
    final isEmpty =
        nickname.trim().isEmpty && plateNumber.trim().isEmpty && model == null;

    return Semantics(
      container: true,
      label: 'Pratinjau kartu motor',
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: scheme.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: ext.borderDefault),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Pratinjau',
              style: textTheme.titleSmall?.copyWith(color: ext.textMuted),
            ),
            const SizedBox(height: 12),
            ExcludeSemantics(
              child: Opacity(
                opacity: isEmpty ? 0.55 : 1,
                child: VehicleSelectCard(
                  layout: VehicleSelectCardLayout.wide,
                  nickname: nickname.trim().isEmpty
                      ? 'Nama motor'
                      : nickname.trim(),
                  plateNumber: plateNumber.trim().isEmpty
                      ? 'Plat nomor'
                      : plateNumber.trim(),
                  caption: model == null
                      ? 'Model motor'
                      : '${modelDisplayName(model!)} · '
                            '${motorCategoryLabel(model!.category)}',
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Begini motormu tampil di Garasi dan saat booking.',
              style: textTheme.bodySmall?.copyWith(color: ext.textMuted),
            ),
          ],
        ),
      ),
    );
  }
}
