import 'package:flutter/material.dart';
import 'package:tumbas_servis/booking/data/util/time_slot_format.dart';
import 'package:tumbas_servis/booking/presentation/pilih_jadwal/components/loading_body.dart';
import 'package:tumbas_servis/booking/presentation/pilih_jadwal/components/slot_chip.dart';
import 'package:tumbas_servis/booking/presentation/pilih_jadwal/components/slot_grid.dart';
import 'package:tumbas_servis/booking/presentation/pilih_jadwal/components/slot_outcome.dart';
import 'package:tumbas_servis/booking/presentation/pilih_jadwal/pilih_jadwal_view_model.dart';
import 'package:tumbas_servis/booking/presentation/pilih_jadwal/state/pilih_jadwal_state.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking_draft.dart';
import 'package:tumbas_servis/core/domain/model/workshop/time_slot.dart';
import 'package:tumbas_servis/core/presentation/theme/ts_theme_extension.dart';

class UnitSlots extends StatelessWidget {
  const UnitSlots({
    required this.motorId,
    required this.state,
    required this.draft,
    required this.viewModel,
    super.key,
  });

  final String motorId;
  final PilihJadwalState state;
  final BookingDraft draft;
  final PilihJadwalViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final ext = TsThemeExtension.of(context);
    final textTheme = Theme.of(context).textTheme;
    final unitSlot = draft.unitSlots[motorId];
    final slots = state.unitSlotsByMotor[motorId] ?? const <TimeSlot>[];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (state.unitSlotsLoading.contains(motorId))
          const SlotSkeletonGrid()
        else
          SlotGrid(
            slots: slots,
            chipBuilder: (slot) {
              final chip = viewModel.splitChipStateFor(slot, motorId, draft);
              final selected =
                  unitSlot != null && unitSlot.slotKey == slot.slotKey;
              Future<void> handleTap() async {
                final outcome = await viewModel.selectUnitSlot(
                  motorId,
                  slot,
                  draft,
                );
                if (context.mounted) {
                  showSlotOutcome(context, outcome, viewModel);
                }
              }

              return SlotChip(
                hour: slot.hour,
                chipState: chip,
                remaining: slot.remaining,
                selected: selected,
                onTap: handleTap,
                onDisabledTap: handleTap,
              );
            },
          ),
        for (final slot in slots)
          if (viewModel.siblingConflictLabel(slot, motorId, draft) != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                viewModel.siblingConflictLabel(slot, motorId, draft)!,
                style: textTheme.bodySmall?.copyWith(color: ext.textMuted),
              ),
            ),
      ],
    );
  }
}
