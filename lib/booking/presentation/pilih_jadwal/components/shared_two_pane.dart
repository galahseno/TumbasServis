import 'package:flutter/material.dart';
import 'package:tumbas_servis/booking/presentation/components/booking_stepper.dart';
import 'package:tumbas_servis/booking/presentation/pilih_jadwal/components/date_grid.dart';
import 'package:tumbas_servis/booking/presentation/pilih_jadwal/components/shared_body.dart';
import 'package:tumbas_servis/booking/presentation/pilih_jadwal/components/slots_pane.dart';
import 'package:tumbas_servis/booking/presentation/pilih_jadwal/pilih_jadwal_view_model.dart';
import 'package:tumbas_servis/booking/presentation/pilih_jadwal/state/pilih_jadwal_state.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking_draft.dart';
import 'package:tumbas_servis/core/presentation/components/max_width_box.dart';

class SharedTwoPane extends StatelessWidget {
  const SharedTwoPane({
    required this.state,
    required this.draft,
    required this.viewModel,
    required this.summaryRow,
    required this.modeToggle,
    required this.footer,
    required this.dateColumnWidth,
    super.key,
  });

  final PilihJadwalState state;
  final BookingDraft draft;
  final PilihJadwalViewModel viewModel;
  final Widget summaryRow;
  final Widget modeToggle;
  final Widget footer;
  final double dateColumnWidth;

  @override
  Widget build(BuildContext context) {
    final selectedDate = state.sharedDate;

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
                    width: dateColumnWidth,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          summaryRow,
                          modeToggle,
                          const SizedBox(height: 8),
                          if (selectedDate != null)
                            DateGrid(
                              today: viewModel.today(),
                              selectedDate: selectedDate,
                              windowDays: scheduleSearchWindowDays,
                              onSelect: viewModel.selectDate,
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: SlotsPane(
                      footer: footer,
                      content: SharedSlots(
                        state: state,
                        draft: draft,
                        unitCount: draft.selectedMotorIds.length,
                        viewModel: viewModel,
                        horizontalPadding: 0,
                      ),
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
