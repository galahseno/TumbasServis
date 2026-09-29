import 'package:flutter/material.dart';
import 'package:tumbas_servis/booking/presentation/pilih_jadwal/pilih_jadwal_view_model.dart';
import 'package:tumbas_servis/booking/presentation/utils/schedule_display.dart';
import 'package:tumbas_servis/core/presentation/components/ts_snackbar.dart';

void showSlotOutcome(
  BuildContext context,
  SlotTapOutcome outcome,
  PilihJadwalViewModel viewModel,
) {
  if (!context.mounted) return;
  switch (outcome) {
    case SlotTapShort(:final slot, :final unitCount):
      TsSnackbar.info(
        context,
        shortSlotMessage(slot, unitCount),
        actionLabel: 'Pisah jadwal',
        onAction: () => viewModel.splitFromShortSlot(slot),
        aboveNavBar: true,
      );
    case SlotTapSiblingConflict(:final slot, :final nickname):
      TsSnackbar.info(
        context,
        siblingConflictMessage(slot, nickname),
        aboveNavBar: true,
      );
    case SlotTapSelected():
    case SlotTapBlocked():
      break;
  }
}
