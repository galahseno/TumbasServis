import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tumbas_servis/app/navigation/routes.dart';
import 'package:tumbas_servis/booking/presentation/booking_draft/booking_draft_view_model.dart';
import 'package:tumbas_servis/booking/presentation/components/booking_stepper.dart';
import 'package:tumbas_servis/booking/presentation/components/exit_booking_dialog.dart';
import 'package:tumbas_servis/booking/presentation/detail_servis/components/complaint_section.dart';
import 'package:tumbas_servis/booking/presentation/detail_servis/components/copy_from_row.dart';
import 'package:tumbas_servis/booking/presentation/detail_servis/components/copy_note.dart';
import 'package:tumbas_servis/booking/presentation/detail_servis/components/copy_source_sheet.dart';
import 'package:tumbas_servis/booking/presentation/detail_servis/components/part_option_tile.dart';
import 'package:tumbas_servis/booking/presentation/detail_servis/components/service_option_tile.dart';
import 'package:tumbas_servis/booking/presentation/detail_servis/components/sticky_estimate_bar.dart';
import 'package:tumbas_servis/booking/presentation/detail_servis/components/unit_header.dart';
import 'package:tumbas_servis/booking/presentation/detail_servis/components/vehicle_tab_chip.dart';
import 'package:tumbas_servis/booking/presentation/detail_servis/detail_servis_view_model.dart';
import 'package:tumbas_servis/booking/presentation/detail_servis/state/detail_servis_state.dart';
import 'package:tumbas_servis/booking/presentation/di/booking_presentation_module.dart';
import 'package:tumbas_servis/booking/presentation/utils/unit_config_display.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking_draft.dart';
import 'package:tumbas_servis/core/domain/model/garage/motor.dart';
import 'package:tumbas_servis/core/presentation/components/empty_state.dart';
import 'package:tumbas_servis/core/presentation/components/error_state.dart';
import 'package:tumbas_servis/core/presentation/components/skeleton.dart';
import 'package:tumbas_servis/core/presentation/components/ts_app_bar.dart';
import 'package:tumbas_servis/core/presentation/components/ts_snackbar.dart';
import 'package:tumbas_servis/core/presentation/theme/ts_theme_extension.dart';
import 'package:tumbas_servis/core/presentation/utils/currency_formatter.dart';

class DetailServisPage extends ConsumerWidget {
  const DetailServisPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final draft = ref.watch(bookingDraftProvider);
    final draftNotifier = ref.read(bookingDraftProvider.notifier);
    final state = ref.watch(detailServisViewModelProvider);
    final viewModel = ref.read(detailServisViewModelProvider.notifier);
    final scheme = Theme.of(context).colorScheme;

    Future<void> handleExit() async {
      final confirmed = await showExitBookingDialog(context);
      if ((confirmed ?? false) && context.mounted) {
        Navigator.of(context).pop();
      }
    }

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
        );
      }
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        handleExit();
      },
      child: Scaffold(
        backgroundColor: scheme.surface,
        appBar: TsAppBar.close(
          title: 'Detail servis',
          onClose: handleExit,
          semanticLabel: 'Tutup booking',
        ),
        body: SafeArea(top: false, child: body),
      ),
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
  });

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

    final activeConfig = unitConfigs[activeMotorId] ?? emptyUnitConfig();
    final activeServiceTypes = selectedServiceTypesFor(
      activeConfig,
      serviceTypes,
    );
    final complaintRequired = isComplaintRequired(activeConfig, serviceTypes);
    final manuallyExpanded = state.manuallyExpandedComplaintMotorIds.contains(
      activeMotorId,
    );
    final complaintExpanded = isComplaintExpanded(
      required: complaintRequired,
      hasNote: (activeConfig.complaintNote ?? '').trim().isNotEmpty,
      manuallyExpanded: manuallyExpanded,
    );
    final complaintErrorText = !activeConfig.isComplaintNoteValid
        ? 'Keluhan maksimal ${UnitConfig.complaintNoteMaxLength} karakter'
        : (complaintRequired &&
              (activeConfig.complaintNote ?? '').trim().isEmpty)
        ? 'Wajib diisi untuk ${activeServiceTypes.firstWhere((s) => s.requiresComplaint).name}'
        : null;

    final copyCandidateIds = copySourceCandidates(
      selectedMotorIds: selectedMotorIds,
      unitConfigs: unitConfigs,
      activeMotorId: activeMotorId,
    );
    final droppedCount = state.droppedPartsCountByMotor[activeMotorId] ?? 0;

    Future<void> handleCopy(String sourceMotorId) async {
      await viewModel.copyFrom(
        draft: draft,
        sourceMotorId: sourceMotorId,
        targetMotorId: activeMotorId,
        targetModelId: activeMotor.modelId,
      );
      if (!context.mounted) return;
      final sourceName = motorsById[sourceMotorId]?.nickname ?? sourceMotorId;
      TsSnackbar.info(
        context,
        'Disalin dari $sourceName',
        actionLabel: 'Urungkan',
        onAction: () => viewModel.undoCopy(activeMotorId),
      );
    }

    Future<void> handleCopyTap() async {
      if (copyCandidateIds.length == 1) {
        await handleCopy(copyCandidateIds.first);
        return;
      }
      final chosen = await showCopySourceSheet(
        context,
        candidates: [
          for (final id in copyCandidateIds)
            CopySourceCandidate(
              motorId: id,
              nickname: motorsById[id]?.nickname ?? id,
              plateNumber: motorsById[id]?.plateNumber ?? '',
            ),
        ],
      );
      if (chosen != null) await handleCopy(chosen);
    }

    final modelParts = viewModel.partsForModel(activeMotor.modelId);
    final breakdown = viewModel.fleetPriceBreakdown(draft);
    final durationMin = viewModel.fleetDurationMin(draft);

    return Stack(
      children: [
        Column(
          children: [
            BookingStepper(currentStep: 2),
            if (selectedMotorIds.length > 1) ...[
              _ChipRow(
                selectedMotorIds: selectedMotorIds,
                motorsById: motorsById,
                chipStatuses: chipStatuses,
                activeMotorId: activeMotorId,
                completeCount: completeCount,
                onSelect: viewModel.setActiveMotor,
              ),
            ],
            Expanded(
              child: SingleChildScrollView(
                key: ValueKey(activeMotorId),
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 140),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    UnitHeader(
                      nickname: activeMotor.nickname,
                      plateNumber: activeMotor.plateNumber,
                      showRemove: selectedMotorIds.length > 1,
                      hasSelections: unitConfigHasSelections(activeConfig),
                      onRemove: () => draftNotifier.removeUnit(activeMotorId),
                    ),
                    if (copyCandidateIds.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      CopyFromRow(
                        label: copyCandidateIds.length == 1
                            ? 'Salin dari '
                                  '${motorsById[copyCandidateIds.first]?.nickname ?? ''}'
                            : 'Salin dari motor lain',
                        showChevron: copyCandidateIds.length > 1,
                        onTap: handleCopyTap,
                      ),
                    ],
                    if (droppedCount > 0) CopyNote(droppedCount: droppedCount),
                    const SizedBox(height: 20),
                    Text(
                      'Jenis servis',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _OptionCard(
                      children: [
                        for (final service in serviceTypes)
                          ServiceOptionTile(
                            name: service.name,
                            subtitle: service.requiresComplaint
                                ? '${CurrencyFormatter.format(service.price)} · '
                                      '${service.durationMin} mnt · Estimasi awal'
                                : '${CurrencyFormatter.format(service.price)} · '
                                      '${service.durationMin} mnt',
                            selected: activeConfig.serviceIds.contains(
                              service.id,
                            ),
                            onChanged: (_) => draftNotifier.toggleService(
                              activeMotorId,
                              service.id,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Suku cadang / oli',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface,
                                ),
                          ),
                        ),
                        TextButton(
                          onPressed: () => TsSnackbar.info(
                            context,
                            'Katalog lengkap segera hadir',
                          ),
                          child: const Text('Lihat semua'),
                        ),
                      ],
                    ),
                    _OptionCard(
                      children: [
                        for (final part in modelParts)
                          PartOptionTile(
                            name: part.name,
                            subtitle:
                                '${CurrencyFormatter.format(part.price)} · '
                                '${part.brand} ${part.grade}',
                            selected: activeConfig.partIds.contains(part.id),
                            onChanged: (_) => draftNotifier.togglePart(
                              activeMotorId,
                              part.id,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    ComplaintSection(
                      key: ValueKey('complaint_$activeMotorId'),
                      expanded: complaintExpanded,
                      required: complaintRequired,
                      initialNote: activeConfig.complaintNote,
                      errorText: complaintErrorText,
                      onExpand: () =>
                          viewModel.toggleComplaintExpanded(activeMotorId),
                      onChanged: (value) => draftNotifier.setComplaintNote(
                        activeMotorId,
                        value.isEmpty ? null : value,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: StickyEstimateBar(
            durationLabel: 'Estimasi · ${formatEstimateDuration(durationMin)}',
            totalLabel: CurrencyFormatter.format(breakdown.total),
            reasonLine: allComplete ? null : reasonLine,
            onContinue: allComplete
                ? () => context.push(Routes.bookingWorkshop)
                : null,
          ),
        ),
      ],
    );
  }
}

class _ChipRow extends StatelessWidget {
  const _ChipRow({
    required this.selectedMotorIds,
    required this.motorsById,
    required this.chipStatuses,
    required this.activeMotorId,
    required this.completeCount,
    required this.onSelect,
  });

  final List<String> selectedMotorIds;
  final Map<String, Motor> motorsById;
  final Map<String, UnitChipStatus> chipStatuses;
  final String activeMotorId;
  final int completeCount;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    final ext = TsThemeExtension.of(context);
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 4),
      child: Row(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (final motorId in selectedMotorIds) ...[
                    VehicleTabChip(
                      label: motorsById[motorId]?.nickname ?? motorId,
                      status: chipStatuses[motorId]!,
                      active: motorId == activeMotorId,
                      semanticLabel:
                          '${motorsById[motorId]?.nickname ?? motorId}, '
                          '${unitChipStatusLabel(chipStatuses[motorId]!)}'
                          '${motorId == activeMotorId ? ', dipilih' : ''}',
                      onTap: () => onSelect(motorId),
                    ),
                    const SizedBox(width: 8),
                  ],
                ],
              ),
            ),
          ),
          Text(
            '$completeCount/${selectedMotorIds.length} ✓',
            style: textTheme.labelMedium?.copyWith(color: ext.textMuted),
          ),
        ],
      ),
    );
  }
}

class _OptionCard extends StatelessWidget {
  const _OptionCard({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final ext = TsThemeExtension.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
        color: scheme.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ext.borderDefault),
      ),
      child: Column(children: children),
    );
  }
}
