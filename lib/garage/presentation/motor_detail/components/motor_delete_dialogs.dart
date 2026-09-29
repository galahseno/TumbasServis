import 'package:flutter/material.dart';
import 'package:tumbas_servis/core/presentation/components/ts_dialog.dart';

Future<bool> showDeleteMotorDialog(
  BuildContext context, {
  required String nickname,
}) async {
  final confirmed = await TsDialog.confirmDestructive(
    context,
    title: 'Hapus $nickname?',
    message:
        'Motor ini akan dihapus dari garasimu dan tidak bisa '
        'dikembalikan.',
  );
  return confirmed ?? false;
}

Future<bool> showMotorDeleteBlockedDialog(
  BuildContext context, {
  required String nickname,
  required String plateNumber,
  required String bookingCode,
}) async {
  final viewBooking = await TsDialog.blockedAction<bool>(
    context,
    title: 'Motor ini punya booking aktif',
    message:
        'Selesaikan atau batalkan booking-nya dulu sebelum menghapus '
        'motor ini.',
    actionLabel: 'Tutup',
    secondaryActionLabel: 'Lihat booking',
    secondaryActionValue: true,
  );
  return viewBooking ?? false;
}
