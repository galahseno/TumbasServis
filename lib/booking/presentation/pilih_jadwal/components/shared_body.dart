import 'package:flutter/material.dart';
import 'package:tumbas_servis/booking/data/util/time_slot_format.dart';
import 'package:tumbas_servis/booking/presentation/components/capacity_banner.dart';
import 'package:tumbas_servis/booking/presentation/pilih_jadwal/components/date_strip.dart';
import 'package:tumbas_servis/booking/presentation/pilih_jadwal/components/loading_body.dart';
import 'package:tumbas_servis/booking/presentation/pilih_jadwal/components/slot_chip.dart';
import 'package:tumbas_servis/booking/presentation/pilih_jadwal/components/slot_grid.dart';
import 'package:tumbas_servis/booking/presentation/pilih_jadwal/components/slot_outcome.dart';
import 'package:tumbas_servis/booking/presentation/pilih_jadwal/pilih_jadwal_view_model.dart';
import 'package:tumbas_servis/booking/presentation/pilih_jadwal/state/pilih_jadwal_state.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking_draft.dart';
import 'package:tumbas_servis/core/domain/service/scheduling/slot_capacity_service.dart';
import 'package:tumbas_servis/core/presentation/components/empty_state.dart';
import 'package:tumbas_servis/core/presentation/theme/ts_theme_extension.dart';
import 'package:tumbas_servis/core/presentation/utils/date_formatter.dart';

class SharedBody extends StatelessWidget {
  const SharedBody({
    required this.state,
    required this.draft,
    required this.unitCount,
    required this.viewModel,
    super.key,
  });

  final PilihJadwalState state;
  final BookingDraft draft;
  final int unitCount;
  final PilihJadwalViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final selectedDate = state.sharedDate;
    if (selectedDate == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DateStrip(
          today: viewModel.today(),
          selectedDate: selectedDate,
          onSelect: viewModel.selectDate,
        ),
        SharedSlots(
          state: state,
          draft: draft,
          unitCount: unitCount,
          viewModel: viewModel,
        ),
      ],
    );
  }
}

class SharedSlots extends StatelessWidget {
  const SharedSlots({
    required this.state,
    required this.draft,
    required this.unitCount,
    required this.viewModel,
    this.horizontalPadding = 20,
    super.key,
  });

  final PilihJadwalState state;
  final BookingDraft draft;
  final int unitCount;
  final PilihJadwalViewModel viewModel;
  final double horizontalPadding;

  @override
  Widget build(BuildContext context) {
    final ext = TsThemeExtension.of(context);
    final textTheme = Theme.of(context).textTheme;
    final selectedDate = state.sharedDate;
    if (selectedDate == null) return const SizedBox.shrink();

    final hPad = horizontalPadding;
    final slots = state.sharedSlots;

    if (state.sharedSlotsLoading) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: hPad),
            child: Text(
              DateFormatter.format(selectedDate),
              style: textTheme.titleSmall?.copyWith(color: ext.textBody),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: EdgeInsets.fromLTRB(hPad, 8, hPad, 0),
            child: const SlotSkeletonGrid(),
          ),
        ],
      );
    }

    final pureFull = viewModel.isDayPureFull(slots);

    if (pureFull) {
      final nextDate = state.allFullNextDate;
      return Column(
        children: [
          const SizedBox(height: 8),
          EmptyState(
            icon: Icons.event_busy_rounded,
            title: 'Semua jam penuh',
            body:
                'Coba tanggal lain — masih ada jam kosong di hari '
                'berikutnya.',
            ctaLabel: nextDate == null
                ? null
                : 'Lihat ${DateFormatter.formatShort(nextDate)}',
            onCta: nextDate == null
                ? null
                : () => viewModel.selectDate(nextDate),
          ),
        ],
      );
    }

    final now = viewModel.now();
    final chipStates = {
      for (final slot in slots)
        slot: viewModel.sharedChipStateFor(slot, unitCount),
    };
    final anyShort = chipStates.values.contains(SlotChipState.short);
    final noneFit = viewModel.noHourFits(slots, unitCount, now);
    final bannerMargin = EdgeInsets.symmetric(horizontal: hPad, vertical: 8);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: hPad),
          child: Text(
            DateFormatter.format(selectedDate),
            style: textTheme.titleSmall?.copyWith(color: ext.textBody),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: hPad),
          child: Text(
            'Jam datang untuk $unitCount motor',
            style: textTheme.bodySmall?.copyWith(color: ext.textMuted),
          ),
        ),
        const SizedBox(height: 8),
        if (noneFit)
          CapacityBanner(
            tone: CapacityBannerTone.warning,
            title: 'Kapasitas tidak cukup untuk $unitCount motor',
            body: 'Tidak ada jam kosong yang muat semua motor hari ini.',
            actionLabel: 'Pisah jadwal per motor',
            margin: bannerMargin,
            onAction: () => viewModel.setScheduleMode(ScheduleMode.split),
          )
        else if (anyShort)
          CapacityBanner(
            tone: CapacityBannerTone.info,
            title: 'Beberapa jam hanya muat 1–2 motor',
            actionLabel: 'Pisah jadwal',
            margin: bannerMargin,
            onAction: () => viewModel.setScheduleMode(ScheduleMode.split),
          ),
        Padding(
          padding: EdgeInsets.fromLTRB(hPad, 8, hPad, 0),
          child: SlotGrid(
            slots: slots,
            chipBuilder: (slot) {
              final chip = chipStates[slot]!;
              final selected =
                  draft.sharedSlot != null &&
                  draft.sharedSlot!.slotKey == slot.slotKey;
              return SlotChip(
                hour: slot.hour,
                chipState: chip,
                remaining: slot.remaining,
                selected: selected,
                onTap: () async {
                  final outcome = await viewModel.selectSharedSlot(
                    slot,
                    unitCount,
                  );
                  if (context.mounted) {
                    showSlotOutcome(context, outcome, viewModel);
                  }
                },
              );
            },
          ),
        ),
        if (chipStates.values.contains(SlotChipState.lewat))
          Padding(
            padding: EdgeInsets.fromLTRB(hPad, 8, hPad, 0),
            child: Text(
              'Booking hari ini minimal 2 jam sebelum jam datang.',
              style: textTheme.bodySmall?.copyWith(color: ext.textMuted),
            ),
          ),
      ],
    );
  }
}
