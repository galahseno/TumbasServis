import 'package:flutter/material.dart';
import 'package:tumbas_servis/core/presentation/components/ts_dialog.dart';

Future<bool?> showExitBookingDialog(BuildContext context) {
  return TsDialog.confirmSave(
    context,
    title: 'Keluar dari booking?',
    message: 'Draft akan disimpan.',
    confirmLabel: 'Simpan & keluar',
    cancelLabel: 'Lanjutkan booking',
  );
}
