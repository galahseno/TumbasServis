import 'package:flutter/material.dart';
import 'package:tumbas_servis/booking/presentation/components/booking_stepper.dart';
import 'package:tumbas_servis/booking/presentation/components/unit_rail.dart';
import 'package:tumbas_servis/booking/presentation/pilih_jadwal/components/date_grid.dart';
import 'package:tumbas_servis/booking/presentation/pilih_jadwal/components/slots_pane.dart';
import 'package:tumbas_servis/booking/presentation/pilih_jadwal/components/unit_slots.dart';
import 'package:tumbas_servis/booking/presentation/pilih_jadwal/pilih_jadwal_view_model.dart';
import 'package:tumbas_servis/booking/presentation/pilih_jadwal/state/pilih_jadwal_state.dart';
import 'package:tumbas_servis/booking/presentation/utils/schedule_display.dart';
import 'package:tumbas_servis/booking/presentation/utils/unit_config_display.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking_draft.dart';
import 'package:tumbas_servis/core/presentation/components/max_width_box.dart';
import 'package:tumbas_servis/core/presentation/theme/ts_theme_extension.dart';
import 'package:tumbas_servis/core/presentation/utils/date_formatter.dart';

class SplitThreePane extends StatefulWidget {
  const SplitThreePane({
    required this.state,
    required this.draft,
    required this.viewModel,
    required this.summaryRow,
    required this.modeToggle,
    required this.footer,
    super.key,
  });

  final PilihJadwalState state;
  final BookingDraft draft;
  final PilihJadwalViewModel viewModel;
  final Widget summaryRow;
  final Widget modeToggle;
  final Widget footer;

  @override
  State<SplitThreePane> createState() => _SplitThreePaneState();
}

class _SplitThreePaneState extends State<SplitThreePane> {
  @override
  void initState() {
    super.initState();
    _ensureActiveUnit();
  }

  @override
  void didUpdateWidget(SplitThreePane oldWidget) {
    super.didUpdateWidget(oldWidget);
    _ensureActiveUnit();
  }

  void _ensureActiveUnit() {
    final ids = widget.draft.selectedMotorIds;
    if (ids.isEmpty) return;
    final open = widget.state.expandedMotorId;
    if (open != null && ids.contains(open)) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final current = widget.state.expandedMotorId;
      if (current == null || !ids.contains(current)) {
        widget.viewModel.toggleExpanded(ids.first);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    final draft = widget.draft;
    final viewModel = widget.viewModel;
    final ids = draft.selectedMotorIds;
    final activeId = state.expandedMotorId != null
        ? (ids.contains(state.expandedMotorId) ? state.expandedMotorId : null)
        : null;
    final active = activeId ?? (ids.isEmpty ? null : ids.first);
    final today = viewModel.today();
    final textTheme = Theme.of(context).textTheme;
    final ext = TsThemeExtension.of(context);

    final rail = UnitRail(
      activeId: active,
      onSelect: (id) {
        if (state.expandedMotorId != id) viewModel.toggleExpanded(id);
      },
      items: [
        for (final motorId in ids)
          UnitRailItem(
            id: motorId,
            title: state.motorsById[motorId]?.nickname ?? motorId,
            subtitle:
                '${state.motorsById[motorId]?.plateNumber ?? ''} · '
                '${draft.unitSlots[motorId] != null ? slotRecapLabel(draft.unitSlots[motorId]!) : 'Pilih jam'}',
            status: draft.unitSlots[motorId] != null
                ? UnitChipStatus.complete
                : UnitChipStatus.incomplete,
          ),
      ],
    );

    Widget slotsContent() {
      if (active == null) return const SizedBox.shrink();
      final unitDate = state.unitDates[active] ?? state.sharedDate ?? today;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${state.motorsById[active]?.nickname ?? active} · '
            '${DateFormatter.format(unitDate)}',
            style: textTheme.titleSmall?.copyWith(color: ext.textBody),
          ),
          const SizedBox(height: 8),
          UnitSlots(
            motorId: active,
            state: state,
            draft: draft,
            viewModel: viewModel,
          ),
        ],
      );
    }

    return Column(
      children: [
        BookingStepper(currentStep: 3),
        Expanded(
          child: MaxWidthBox(
            maxWidth: 1280,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    width: UnitRail.width,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          widget.summaryRow,
                          widget.modeToggle,
                          const SizedBox(height: 8),
                          rail,
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    flex: 420,
                    child: SingleChildScrollView(
                      child: active == null
                          ? const SizedBox.shrink()
                          : DateGrid(
                              today: today,
                              selectedDate:
                                  state.unitDates[active] ??
                                  state.sharedDate ??
                                  today,
                              windowDays: scheduleSearchWindowDays,
                              onSelect: (date) =>
                                  viewModel.selectUnitDate(active, date),
                            ),
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    flex: 512,
                    child: SlotsPane(
                      footer: widget.footer,
                      content: slotsContent(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
