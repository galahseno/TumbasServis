import 'package:flutter/material.dart';
import 'package:tumbas_servis/booking/presentation/booking_draft/booking_draft_view_model.dart';
import 'package:tumbas_servis/booking/presentation/detail_servis/components/complaint_section.dart';
import 'package:tumbas_servis/booking/presentation/detail_servis/components/copy_from_row.dart';
import 'package:tumbas_servis/booking/presentation/detail_servis/components/copy_note.dart';
import 'package:tumbas_servis/booking/presentation/detail_servis/components/copy_source_sheet.dart';
import 'package:tumbas_servis/booking/presentation/detail_servis/components/option_card.dart';
import 'package:tumbas_servis/booking/presentation/detail_servis/components/service_option_tile.dart';
import 'package:tumbas_servis/booking/presentation/detail_servis/components/unit_header.dart';
import 'package:tumbas_servis/booking/presentation/detail_servis/detail_servis_view_model.dart';
import 'package:tumbas_servis/booking/presentation/detail_servis/state/detail_servis_state.dart';
import 'package:tumbas_servis/booking/presentation/utils/unit_config_display.dart';
import 'package:tumbas_servis/catalog/presentation/katalog/katalog_page.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking_draft.dart';
import 'package:tumbas_servis/core/domain/model/garage/motor.dart';
import 'package:tumbas_servis/core/presentation/components/part_option_tile.dart';
import 'package:tumbas_servis/core/presentation/components/ts_snackbar.dart';
import 'package:tumbas_servis/core/presentation/utils/currency_formatter.dart';

class ServisForm extends StatelessWidget {
  const ServisForm({
    required this.draft,
    required this.state,
    required this.activeMotorId,
    required this.activeMotor,
    required this.draftNotifier,
    required this.viewModel,
    required this.onOpenPartsCatalog,
    super.key,
  });

  final BookingDraft draft;
  final DetailServisState state;
  final String activeMotorId;
  final Motor activeMotor;
  final BookingDraftViewModel draftNotifier;
  final DetailServisViewModel viewModel;
  final Future<List<String>?> Function(KatalogSelectArgs args)
  onOpenPartsCatalog;

  @override
  Widget build(BuildContext context) {
    final unitConfigs = draft.unitConfigs;
    final serviceTypes = state.serviceTypes;
    final motorsById = state.motorsById;

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
      selectedMotorIds: draft.selectedMotorIds,
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        UnitHeader(
          nickname: activeMotor.nickname,
          plateNumber: activeMotor.plateNumber,
          showRemove: draft.selectedMotorIds.length > 1,
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
        OptionCard(
          children: [
            for (final service in serviceTypes)
              ServiceOptionTile(
                name: service.name,
                subtitle: service.requiresComplaint
                    ? '${CurrencyFormatter.format(service.price)} · '
                          '${service.durationMin} mnt · Estimasi awal'
                    : '${CurrencyFormatter.format(service.price)} · '
                          '${service.durationMin} mnt',
                selected: activeConfig.serviceIds.contains(service.id),
                onChanged: (_) =>
                    draftNotifier.toggleService(activeMotorId, service.id),
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
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                final result = await onOpenPartsCatalog(
                  KatalogSelectArgs(
                    modelId: activeMotor.modelId,
                    initialPartIds: activeConfig.partIds,
                    unitNickname: activeMotor.nickname,
                    unitPlateNumber: activeMotor.plateNumber,
                  ),
                );
                if (result != null && context.mounted) {
                  await draftNotifier.setUnitConfig(
                    activeMotorId,
                    activeConfig.copyWith(partIds: result),
                  );
                }
              },
              child: const Text('Lihat semua'),
            ),
          ],
        ),
        OptionCard(
          children: [
            for (final part in modelParts)
              PartOptionTile(
                name: part.name,
                subtitle:
                    '${CurrencyFormatter.format(part.price)} · '
                    '${part.brand} ${part.grade}',
                selected: activeConfig.partIds.contains(part.id),
                onChanged: (_) =>
                    draftNotifier.togglePart(activeMotorId, part.id),
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
          onExpand: () => viewModel.toggleComplaintExpanded(activeMotorId),
          onChanged: (value) => draftNotifier.setComplaintNote(
            activeMotorId,
            value.isEmpty ? null : value,
          ),
        ),
      ],
    );
  }
}
