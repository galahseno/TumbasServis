import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tumbas_servis/core/data/service/photo_picker_service.dart';
import 'package:tumbas_servis/core/presentation/components/ts_button.dart';
import 'package:tumbas_servis/core/presentation/components/ts_dialog.dart';
import 'package:tumbas_servis/core/presentation/theme/ts_theme_extension.dart';

enum _PhotoAction { camera, gallery, remove }

class MotorPhotoField extends StatelessWidget {
  const MotorPhotoField({
    required this.photoPath,
    required this.onPick,
    required this.onRemove,
    super.key,
    this.enabled = true,
  });

  final String? photoPath;
  final ValueChanged<PhotoPickSource> onPick;
  final VoidCallback onRemove;
  final bool enabled;

  Future<void> _openChooser(BuildContext context) async {
    final choice = await TsDialog.choiceList<_PhotoAction>(
      context,
      title: 'Foto motor',
      choices: [
        const TsDialogChoice(
          label: 'Kamera',
          value: _PhotoAction.camera,
          icon: Icons.photo_camera_outlined,
        ),
        const TsDialogChoice(
          label: 'Galeri',
          value: _PhotoAction.gallery,
          icon: Icons.photo_library_outlined,
        ),
        if (photoPath != null)
          const TsDialogChoice(
            label: 'Hapus foto',
            value: _PhotoAction.remove,
            icon: Icons.delete_outline_rounded,
          ),
      ],
    );
    switch (choice) {
      case _PhotoAction.camera:
        onPick(PhotoPickSource.camera);
      case _PhotoAction.gallery:
        onPick(PhotoPickSource.gallery);
      case _PhotoAction.remove:
        onRemove();
      case null:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final ext = TsThemeExtension.of(context);
    final textTheme = Theme.of(context).textTheme;

    final placeholder = Icon(
      Icons.two_wheeler_rounded,
      size: 48,
      color: ext.textFaint,
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ExcludeSemantics(
          child: Container(
            width: 96,
            height: 96,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: scheme.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: ext.borderDefault),
            ),
            alignment: Alignment.center,
            child: photoPath == null
                ? placeholder
                : Image.file(
                    File(photoPath!),
                    width: 96,
                    height: 96,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => placeholder,
                  ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TsButton(
                label: photoPath == null ? 'Tambah foto' : 'Ubah foto',
                type: TsButtonType.outline,
                compact: true,
                fullWidth: false,
                leadingIcon: Icons.photo_camera_outlined,
                onPressed: enabled ? () => _openChooser(context) : null,
              ),
              const SizedBox(height: 8),
              Text(
                'Opsional. Tanpa foto, kami pakai gambar bawaan sesuai jenis '
                'motor.',
                style: textTheme.bodySmall?.copyWith(color: ext.textMuted),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
