import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tumbas_servis/app/navigation/routes.dart';
import 'package:tumbas_servis/booking/data/util/time_slot_format.dart';
import 'package:tumbas_servis/booking/presentation/components/booking_stepper.dart';
import 'package:tumbas_servis/booking/presentation/components/capacity_banner.dart';
import 'package:tumbas_servis/booking/presentation/components/workshop_summary_row.dart';
import 'package:tumbas_servis/booking/presentation/di/booking_presentation_module.dart';
import 'package:tumbas_servis/booking/presentation/pilih_jadwal/components/date_strip_item.dart';
import 'package:tumbas_servis/booking/presentation/pilih_jadwal/components/schedule_mode_toggle.dart';
import 'package:tumbas_servis/booking/presentation/pilih_jadwal/components/slot_chip.dart';
import 'package:tumbas_servis/booking/presentation/pilih_jadwal/components/unit_slot_section.dart';
import 'package:tumbas_servis/booking/presentation/pilih_jadwal/pilih_jadwal_view_model.dart';
import 'package:tumbas_servis/booking/presentation/pilih_jadwal/state/pilih_jadwal_state.dart';
import 'package:tumbas_servis/booking/presentation/utils/schedule_display.dart';
import 'package:tumbas_servis/booking/presentation/utils/summary_navigation.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking_draft.dart';
import 'package:tumbas_servis/core/domain/model/workshop/time_slot.dart';
import 'package:tumbas_servis/core/domain/service/scheduling/slot_capacity_service.dart';
import 'package:tumbas_servis/core/presentation/components/empty_state.dart';
import 'package:tumbas_servis/core/presentation/components/error_state.dart';
import 'package:tumbas_servis/core/presentation/components/selection_footer.dart';
import 'package:tumbas_servis/core/presentation/components/skeleton.dart';
import 'package:tumbas_servis/core/presentation/components/ts_app_bar.dart';
import 'package:tumbas_servis/core/presentation/components/ts_snackbar.dart';
import 'package:tumbas_servis/core/presentation/theme/ts_theme_extension.dart';
import 'package:tumbas_servis/core/presentation/utils/date_formatter.dart';

class PilihJadwalPage extends ConsumerWidget {
  const PilihJadwalPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final draft = ref.watch(bookingDraftProvider);
    final editingFromSummary = ref.watch(summaryEditReturnProvider);
    final state = ref.watch(pilihJadwalViewModelProvider);
    final viewModel = ref.read(pilihJadwalViewModelProvider.notifier);
    final scheme = Theme.of(context).colorScheme;

    Widget body;
    if (state.hasError) {
      body = ErrorState(
        message: 'Jadwal gagal dimuat. Coba lagi.',
        onRetry: viewModel.retry,
        layout: ErrorStateLayout.fullPage,
      );
    } else if (state.isLoading || draft == null) {
      body = const _LoadingBody();
    } else {
      final isSplit = draft.scheduleMode == ScheduleMode.split;
      body = Column(
        children: [
          BookingStepper(currentStep: 3),
          WorkshopSummaryRow(
            workshopName: state.workshop?.name ?? '',
            bayCount: state.workshop?.bayCount ?? 0,
            onUbah: () => context.pop(),
          ),
          ScheduleModeToggle(
            splitMode: isSplit,
            onChanged: (value) => viewModel.setScheduleMode(
              value ? ScheduleMode.split : ScheduleMode.shared,
            ),
          ),
          const SizedBox(height: 4),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 12),
              child: isSplit
                  ? _SplitBody(state: state, draft: draft, viewModel: viewModel)
                  : _SharedBody(
                      state: state,
                      draft: draft,
                      unitCount: draft.selectedMotorIds.length,
                      viewModel: viewModel,
                    ),
            ),
          ),
          SelectionFooter(
            recapLine: scheduleRecapLine(draft, state.sharedDate),
            reasonLine: scheduleReasonLine(draft, state.motorsById),
            ctaLabel: 'Lanjut',
            canContinue: canContinueSchedule(draft),
            onContinue: () => editingFromSummary
                ? returnToSummary(context)
                : context.push(Routes.bookingSummary),
          ),
        ],
      );
    }

    return Scaffold(
      backgroundColor: scheme.surface,
      appBar: TsAppBar.back(title: 'Pilih jadwal'),
      body: SafeArea(top: false, child: body),
    );
  }
}

class _LoadingBody extends StatelessWidget {
  const _LoadingBody();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BookingStepper(currentStep: 3),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: SkeletonBlock(height: 40),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: SkeletonBlock(height: 48),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
            children: [
              const SkeletonBlock(height: 72),
              const SizedBox(height: 12),
              const _SlotSkeletonGrid(),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.fromLTRB(20, 12, 20, 12),
          child: SkeletonBlock(height: 48),
        ),
      ],
    );
  }
}

class _SlotSkeletonGrid extends StatelessWidget {
  const _SlotSkeletonGrid();

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Memuat jam tersedia',
      child: ExcludeSemantics(
        child: GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 3,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: 1.4,
          children: [
            for (var i = 0; i < 9; i++) const SkeletonBlock(height: 54),
          ],
        ),
      ),
    );
  }
}

void _showSlotOutcome(
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

List<DateTime> _dateRange(DateTime today) => [
  for (var i = 0; i <= scheduleSearchWindowDays; i++)
    today.add(Duration(days: i)),
];

class _DateStrip extends StatelessWidget {
  const _DateStrip({
    required this.today,
    required this.selectedDate,
    required this.onSelect,
  });

  final DateTime today;
  final DateTime selectedDate;
  final ValueChanged<DateTime> onSelect;

  @override
  Widget build(BuildContext context) {
    final dates = _dateRange(today);
    return SizedBox(
      height: 80,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: dates.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final date = dates[index];
          return DateStripItem(
            date: date,
            today: date == today,
            selected: date == selectedDate,
            onTap: () => onSelect(date),
          );
        },
      ),
    );
  }
}

class _SlotGrid extends StatelessWidget {
  const _SlotGrid({required this.slots, required this.chipBuilder});

  final List<TimeSlot> slots;
  final Widget Function(TimeSlot slot) chipBuilder;

  @override
  Widget build(BuildContext context) {
    // Fixed aspect ratio clips the chip's caption at larger text scales, so the
    // row height follows the text scale instead (54dp floor, PRD 06 48dp min).
    final extent = math.max(
      54.0,
      MediaQuery.textScalerOf(context).scale(40) + 18,
    );
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        mainAxisExtent: extent,
      ),
      itemCount: slots.length,
      itemBuilder: (context, index) => chipBuilder(slots[index]),
    );
  }
}

class _SharedBody extends StatelessWidget {
  const _SharedBody({
    required this.state,
    required this.draft,
    required this.unitCount,
    required this.viewModel,
  });

  final PilihJadwalState state;
  final BookingDraft draft;
  final int unitCount;
  final PilihJadwalViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final ext = TsThemeExtension.of(context);
    final textTheme = Theme.of(context).textTheme;
    final selectedDate = state.sharedDate;
    if (selectedDate == null) return const SizedBox.shrink();

    final today = viewModel.today();
    final slots = state.sharedSlots;

    if (state.sharedSlotsLoading) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _DateStrip(
            today: today,
            selectedDate: selectedDate,
            onSelect: viewModel.selectDate,
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              DateFormatter.format(selectedDate),
              style: textTheme.titleSmall?.copyWith(color: ext.textBody),
            ),
          ),
          const SizedBox(height: 8),
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 8, 20, 0),
            child: _SlotSkeletonGrid(),
          ),
        ],
      );
    }

    final pureFull = viewModel.isDayPureFull(slots);

    if (pureFull) {
      final nextDate = state.allFullNextDate;
      return Column(
        children: [
          _DateStrip(
            today: today,
            selectedDate: selectedDate,
            onSelect: viewModel.selectDate,
          ),
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _DateStrip(
          today: today,
          selectedDate: selectedDate,
          onSelect: viewModel.selectDate,
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            DateFormatter.format(selectedDate),
            style: textTheme.titleSmall?.copyWith(color: ext.textBody),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
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
            onAction: () => viewModel.setScheduleMode(ScheduleMode.split),
          )
        else if (anyShort)
          CapacityBanner(
            tone: CapacityBannerTone.info,
            title: 'Beberapa jam hanya muat 1–2 motor',
            actionLabel: 'Pisah jadwal',
            onAction: () => viewModel.setScheduleMode(ScheduleMode.split),
          ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
          child: _SlotGrid(
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
                    _showSlotOutcome(context, outcome, viewModel);
                  }
                },
              );
            },
          ),
        ),
        if (chipStates.values.contains(SlotChipState.lewat))
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
            child: Text(
              'Booking hari ini minimal 2 jam sebelum jam datang.',
              style: textTheme.bodySmall?.copyWith(color: ext.textMuted),
            ),
          ),
      ],
    );
  }
}

class _SplitBody extends StatelessWidget {
  const _SplitBody({
    required this.state,
    required this.draft,
    required this.viewModel,
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
            _UnitSection(
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

class _UnitSection extends StatelessWidget {
  const _UnitSection({
    required this.motorId,
    required this.state,
    required this.draft,
    required this.viewModel,
  });

  final String motorId;
  final PilihJadwalState state;
  final BookingDraft draft;
  final PilihJadwalViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final ext = TsThemeExtension.of(context);
    final textTheme = Theme.of(context).textTheme;
    final motor = state.motorsById[motorId];
    final unitSlot = draft.unitSlots[motorId];
    final expanded = state.expandedMotorId == motorId;
    final today = viewModel.today();
    final unitDate = state.unitDates[motorId] ?? state.sharedDate ?? today;
    final slots = state.unitSlotsByMotor[motorId] ?? const <TimeSlot>[];

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
          _DateStrip(
            today: today,
            selectedDate: unitDate,
            onSelect: (date) => viewModel.selectUnitDate(motorId, date),
          ),
          const SizedBox(height: 8),
          if (state.unitSlotsLoading.contains(motorId))
            const _SlotSkeletonGrid()
          else
            _SlotGrid(
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
                    _showSlotOutcome(context, outcome, viewModel);
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
      ),
    );
  }
}
