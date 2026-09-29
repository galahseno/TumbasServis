import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tumbas_servis/app/navigation/routes.dart';
import 'package:tumbas_servis/booking/presentation/booking_draft/booking_draft_view_model.dart';
import 'package:tumbas_servis/booking/presentation/components/booking_stepper.dart';
import 'package:tumbas_servis/booking/presentation/components/unit_rail.dart';
import 'package:tumbas_servis/booking/presentation/detail_servis/components/chip_row.dart';
import 'package:tumbas_servis/booking/presentation/detail_servis/components/estimate_pane.dart';
import 'package:tumbas_servis/booking/presentation/detail_servis/components/servis_form.dart';
import 'package:tumbas_servis/booking/presentation/detail_servis/components/sticky_estimate_bar.dart';
import 'package:tumbas_servis/booking/presentation/detail_servis/detail_servis_view_model.dart';
import 'package:tumbas_servis/booking/presentation/detail_servis/state/detail_servis_state.dart';
import 'package:tumbas_servis/booking/presentation/di/booking_presentation_module.dart';
import 'package:tumbas_servis/booking/presentation/utils/summary_navigation.dart';
import 'package:tumbas_servis/booking/presentation/utils/unit_config_display.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking_draft.dart';
import 'package:tumbas_servis/core/domain/model/garage/motor.dart';
import 'package:tumbas_servis/core/presentation/components/empty_state.dart';
import 'package:tumbas_servis/core/presentation/components/error_state.dart';
import 'package:tumbas_servis/core/presentation/components/max_width_box.dart';
import 'package:tumbas_servis/core/presentation/components/skeleton.dart';
import 'package:tumbas_servis/core/presentation/components/ts_app_bar.dart';
import 'package:tumbas_servis/core/presentation/utils/currency_formatter.dart';
import 'package:tumbas_servis/core/presentation/utils/window_size_class.dart';

class DetailServisPage extends ConsumerWidget {
  const DetailServisPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final draft = ref.watch(bookingDraftProvider);
    final editingFromSummary = ref.watch(summaryEditReturnProvider);
    final draftNotifier = ref.read(bookingDraftProvider.notifier);
    final state = ref.watch(detailServisViewModelProvider);
    final viewModel = ref.read(detailServisViewModelProvider.notifier);
    final scheme = Theme.of(context).colorScheme;

    Widget body;
    if (draft == null || state.isLoading) {
      body = const _LoadingBody();
    } else if (state.hasError) {
      body = ErrorState(
        message: 'Katalog gagal dimuat. Coba lagi.',
        onRetry: viewModel.retry,
        layout: ErrorStateLayout.fullPage,
      );
    } else {
      final activeMotorId = resolveActiveMotorId(
        state.activeMotorId,
        draft.selectedMotorIds,
      );
      if (activeMotorId == null) {
        body = EmptyState(
          title: 'Belum ada motor dipilih',
          body: 'Kembali ke langkah sebelumnya untuk memilih motor.',
          ctaLabel: 'Pilih motor',
          onCta: () => Navigator.of(context).pop(),
        );
      } else if (state.motorsById[activeMotorId] == null) {
        body = const _LoadingBody();
      } else {
        final activeMotor = state.motorsById[activeMotorId]!;
        body = _DetailServisBody(
          draft: draft,
          state: state,
          activeMotorId: activeMotorId,
          activeMotor: activeMotor,
          draftNotifier: draftNotifier,
          viewModel: viewModel,
          editingFromSummary: editingFromSummary,
        );
      }
    }

    return Scaffold(
      backgroundColor: scheme.surface,
      appBar: TsAppBar.back(title: 'Detail servis'),
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
        BookingStepper(currentStep: 2),
        const Expanded(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                SkeletonBlock(height: 48),
                SizedBox(height: 16),
                SkeletonBlock(height: 200),
                SizedBox(height: 16),
                SkeletonBlock(height: 160),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _DetailServisBody extends StatelessWidget {
  const _DetailServisBody({
    required this.draft,
    required this.state,
    required this.activeMotorId,
    required this.activeMotor,
    required this.draftNotifier,
    required this.viewModel,
    required this.editingFromSummary,
  });

  final bool editingFromSummary;
  final BookingDraft draft;
  final DetailServisState state;
  final String activeMotorId;
  final Motor activeMotor;
  final BookingDraftViewModel draftNotifier;
  final DetailServisViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final selectedMotorIds = draft.selectedMotorIds;
    final unitConfigs = draft.unitConfigs;
    final serviceTypes = state.serviceTypes;
    final motorsById = state.motorsById;

    final chipStatuses = {
      for (final motorId in selectedMotorIds)
        motorId: unitChipStatus(
          unitConfigs[motorId] ?? emptyUnitConfig(),
          serviceTypes,
        ),
    };
    final completeCount = chipStatuses.values
        .where((status) => status == UnitChipStatus.complete)
        .length;
    final allComplete = completeCount == selectedMotorIds.length;
    final reasonLine = lanjutBlockedReason(
      selectedMotorIds: selectedMotorIds,
      unitConfigs: unitConfigs,
      catalogServices: serviceTypes,
      nicknameFor: (id) => motorsById[id]?.nickname ?? id,
    );

    final breakdown = viewModel.fleetPriceBreakdown(draft);
    final durationMin = viewModel.fleetDurationMin(draft);

    final form = ServisForm(
      draft: draft,
      state: state,
      activeMotorId: activeMotorId,
      activeMotor: activeMotor,
      draftNotifier: draftNotifier,
      viewModel: viewModel,
      onOpenPartsCatalog: (args) =>
          context.push<List<String>>(Routes.bookingConfigureParts, extra: args),
    );

    final sizeClass = context.windowSizeClass;
    final isMulti = selectedMotorIds.length > 1;
    final isLarge = sizeClass == WindowSizeClass.large;
    final useRail = isMulti && sizeClass.isAtLeast(WindowSizeClass.expanded);
    final showPill = !isLarge;
    final stackedMaxWidth = sizeClass.isCompact ? null : _stackedMaxWidth;

    final continueAction = allComplete
        ? () => editingFromSummary
              ? returnToSummary(context)
              : context.push(Routes.bookingWorkshop)
        : null;

    Widget formScroll() => SingleChildScrollView(
      key: ValueKey(activeMotorId),
      padding: EdgeInsets.fromLTRB(20, 8, 20, showPill ? 140 : 24),
      child: form,
    );

    Widget pill() => StickyEstimateBar(
      durationLabel: 'Estimasi · ${formatEstimateDuration(durationMin)}',
      totalLabel: CurrencyFormatter.format(breakdown.total),
      reasonLine: allComplete ? null : reasonLine,
      onContinue: continueAction,
    );

    final rail = UnitRail(
      activeId: activeMotorId,
      onSelect: viewModel.setActiveMotor,
      items: [
        for (final motorId in selectedMotorIds)
          UnitRailItem(
            id: motorId,
            title: motorsById[motorId]?.nickname ?? motorId,
            subtitle:
                '${motorsById[motorId]?.plateNumber ?? ''} · '
                '${unitChipStatusLabel(chipStatuses[motorId]!)}',
            status: chipStatuses[motorId]!,
          ),
      ],
    );

    Widget estimatePane() => EstimatePane(
      lines: [
        for (final motorId in selectedMotorIds)
          EstimatePaneLine(
            label: motorsById[motorId]?.nickname ?? motorId,
            subtotal:
                (unitConfigs[motorId] ?? emptyUnitConfig()).serviceIds.isEmpty
                ? null
                : viewModel.unitSubtotal(
                    unitConfigs[motorId] ?? emptyUnitConfig(),
                  ),
          ),
      ],
      totalLabel: CurrencyFormatter.format(breakdown.total),
      durationLabel: 'Estimasi · ${formatEstimateDuration(durationMin)}',
      reasonLine: allComplete ? null : reasonLine,
      onContinue: continueAction,
    );

    if (isLarge) {
      return Column(
        children: [
          BookingStepper(currentStep: 2),
          Expanded(
            child: MaxWidthBox(
              maxWidth: isMulti ? 1280 : 720 + 24 + 360 + 48,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (isMulti) ...[
                      SizedBox(
                        width: UnitRail.width,
                        child: SingleChildScrollView(child: rail),
                      ),
                      const SizedBox(width: 24),
                    ],
                    Expanded(child: formScroll()),
                    const SizedBox(width: 24),
                    SizedBox(
                      width: 360,
                      child: SingleChildScrollView(child: estimatePane()),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    }

    if (useRail) {
      const railGap = 24.0;
      return Stack(
        children: [
          Column(
            children: [
              BookingStepper(currentStep: 2),
              Expanded(
                child: MaxWidthBox(
                  maxWidth: 1024,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(
                          width: UnitRail.width,
                          child: SingleChildScrollView(child: rail),
                        ),
                        const SizedBox(width: railGap),
                        Expanded(child: formScroll()),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: MaxWidthBox(
              maxWidth: 1024,
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 24 + UnitRail.width + railGap,
                  right: 24,
                ),
                child: pill(),
              ),
            ),
          ),
        ],
      );
    }

    Widget capped(Widget child) => stackedMaxWidth == null
        ? child
        : MaxWidthBox(maxWidth: stackedMaxWidth, child: child);

    return Stack(
      children: [
        Column(
          children: [
            BookingStepper(currentStep: 2),
            if (isMulti)
              capped(
                ChipRow(
                  selectedMotorIds: selectedMotorIds,
                  motorsById: motorsById,
                  chipStatuses: chipStatuses,
                  activeMotorId: activeMotorId,
                  completeCount: completeCount,
                  onSelect: viewModel.setActiveMotor,
                ),
              ),
            Expanded(child: capped(formScroll())),
          ],
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: stackedMaxWidth == null
              ? pill()
              : MaxWidthBox(maxWidth: stackedMaxWidth + 32, child: pill()),
        ),
      ],
    );
  }
}

const _stackedMaxWidth = 720.0;
