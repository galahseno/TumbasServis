import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tumbas_servis/app/navigation/routes.dart';
import 'package:tumbas_servis/booking/presentation/components/booking_stepper.dart';
import 'package:tumbas_servis/booking/presentation/components/workshop_summary_row.dart';
import 'package:tumbas_servis/booking/presentation/di/booking_presentation_module.dart';
import 'package:tumbas_servis/booking/presentation/pilih_jadwal/components/loading_body.dart';
import 'package:tumbas_servis/booking/presentation/pilih_jadwal/components/schedule_mode_toggle.dart';
import 'package:tumbas_servis/booking/presentation/pilih_jadwal/components/shared_body.dart';
import 'package:tumbas_servis/booking/presentation/pilih_jadwal/components/shared_two_pane.dart';
import 'package:tumbas_servis/booking/presentation/pilih_jadwal/components/split_body.dart';
import 'package:tumbas_servis/booking/presentation/pilih_jadwal/components/split_three_pane.dart';
import 'package:tumbas_servis/booking/presentation/utils/schedule_display.dart';
import 'package:tumbas_servis/booking/presentation/utils/summary_navigation.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking_draft.dart';
import 'package:tumbas_servis/core/presentation/components/error_state.dart';
import 'package:tumbas_servis/core/presentation/components/max_width_box.dart';
import 'package:tumbas_servis/core/presentation/components/selection_footer.dart';
import 'package:tumbas_servis/core/presentation/components/ts_app_bar.dart';
import 'package:tumbas_servis/core/presentation/utils/window_size_class.dart';

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
      body = const LoadingBody();
    } else {
      final isSplit = draft.scheduleMode == ScheduleMode.split;
      final sizeClass = context.windowSizeClass;
      final isWide = sizeClass.isAtLeast(WindowSizeClass.expanded);
      final isLarge = sizeClass == WindowSizeClass.large;
      final isMedium = sizeClass == WindowSizeClass.medium;
      final isCappedStack = isMedium || (isSplit && !isLarge && isWide);
      final cappedStackWidth = isCappedStack ? stackedMaxWidth : null;

      SelectionFooter footer({
        double? maxContentWidth,
        Color? backgroundColor,
      }) => SelectionFooter(
        recapLine: scheduleRecapLine(draft, state.sharedDate),
        reasonLine: scheduleReasonLine(draft, state.motorsById),
        ctaLabel: 'Lanjut',
        canContinue: canContinueSchedule(draft),
        maxContentWidth: maxContentWidth,
        backgroundColor: backgroundColor,
        onContinue: () => editingFromSummary
            ? returnToSummary(context)
            : context.push(Routes.bookingSummary),
      );

      final summaryRow = WorkshopSummaryRow(
        workshopName: state.workshop?.name ?? '',
        bayCount: state.workshop?.bayCount ?? 0,
        onUbah: () => context.pop(),
      );
      final modeToggle = ScheduleModeToggle(
        splitMode: isSplit,
        onChanged: (value) => viewModel.setScheduleMode(
          value ? ScheduleMode.split : ScheduleMode.shared,
        ),
      );

      if (isWide && !isSplit) {
        body = SharedTwoPane(
          state: state,
          draft: draft,
          viewModel: viewModel,
          summaryRow: summaryRow,
          modeToggle: modeToggle,
          footer: footer(backgroundColor: scheme.surfaceContainer),
          dateColumnWidth: isLarge ? 480 : 400,
        );
      } else if (isLarge && isSplit) {
        body = SplitThreePane(
          state: state,
          draft: draft,
          viewModel: viewModel,
          summaryRow: summaryRow,
          modeToggle: modeToggle,
          footer: footer(backgroundColor: scheme.surfaceContainer),
        );
      } else {
        final content = isSplit
            ? SplitBody(state: state, draft: draft, viewModel: viewModel)
            : SharedBody(
                state: state,
                draft: draft,
                unitCount: draft.selectedMotorIds.length,
                viewModel: viewModel,
              );
        body = Column(
          children: [
            BookingStepper(currentStep: 3),
            summaryRow,
            modeToggle,
            const SizedBox(height: 4),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 12),
                child: cappedStackWidth == null
                    ? content
                    : MaxWidthBox(maxWidth: cappedStackWidth, child: content),
              ),
            ),
            footer(maxContentWidth: cappedStackWidth),
          ],
        );
      }
    }

    return Scaffold(
      backgroundColor: scheme.surface,
      appBar: TsAppBar.back(title: 'Pilih jadwal'),
      body: SafeArea(top: false, child: body),
    );
  }
}
