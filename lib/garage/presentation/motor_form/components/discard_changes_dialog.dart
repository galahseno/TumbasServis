import 'package:flutter/material.dart';
import 'package:tumbas_servis/core/presentation/components/ts_dialog.dart';

Future<bool> showDiscardChangesDialog(BuildContext context) async {
  final keepEditing = await TsDialog.confirmSave(
    context,
    title: 'Buang perubahan?',
    message: 'Perubahan yang belum disimpan akan hilang.',
    confirmLabel: 'Lanjut mengisi',
    cancelLabel: 'Buang',
  );
  return keepEditing == false;
}
