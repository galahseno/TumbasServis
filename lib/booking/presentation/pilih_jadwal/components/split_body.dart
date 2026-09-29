import 'package:flutter/material.dart';
import 'package:tumbas_servis/booking/presentation/pilih_jadwal/components/date_strip.dart';
import 'package:tumbas_servis/booking/presentation/pilih_jadwal/components/unit_slot_section.dart';
import 'package:tumbas_servis/booking/presentation/pilih_jadwal/components/unit_slots.dart';
import 'package:tumbas_servis/booking/presentation/pilih_jadwal/pilih_jadwal_view_model.dart';
import 'package:tumbas_servis/booking/presentation/pilih_jadwal/state/pilih_jadwal_state.dart';
import 'package:tumbas_servis/booking/presentation/utils/schedule_display.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking_draft.dart';

class SplitBody extends StatelessWidget {
  const SplitBody({
    required this.state,
    required this.draft,
    required this.viewModel,
    super.key,
  });

  final PilihJadwalState state;
  final BookingDraft draft;
  final PilihJadwalViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
      child: Column(
        children: [
          for (final motorId in draft.selectedMotorIds)
            UnitSection(
              motorId: motorId,
              state: state,
              draft: draft,
              viewModel: viewModel,
            ),
        ],
      ),
    );
  }
}

class UnitSection extends StatelessWidget {
  const UnitSection({
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
    final motor = state.motorsById[motorId];
    final unitSlot = draft.unitSlots[motorId];
    final expanded = state.expandedMotorId == motorId;
    final today = viewModel.today();
    final unitDate = state.unitDates[motorId] ?? state.sharedDate ?? today;

    return UnitSlotSection(
      nickname: motor?.nickname ?? motorId,
      plateNumber: motor?.plateNumber ?? '',
      complete: unitSlot != null,
      statusLabel: unitSlot != null ? slotRecapLabel(unitSlot) : 'Pilih jam',
      expanded: expanded,
      onHeaderTap: () => viewModel.toggleExpanded(motorId),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DateStrip(
            today: today,
            selectedDate: unitDate,
            onSelect: (date) => viewModel.selectUnitDate(motorId, date),
          ),
          const SizedBox(height: 8),
          UnitSlots(
            motorId: motorId,
            state: state,
            draft: draft,
            viewModel: viewModel,
          ),
        ],
      ),
    );
  }
}
