import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tumbas_servis/app/navigation/routes.dart';
import 'package:tumbas_servis/booking/presentation/components/booking_stepper.dart';
import 'package:tumbas_servis/booking/presentation/di/booking_presentation_module.dart';
import 'package:tumbas_servis/booking/presentation/utils/unit_config_display.dart';
import 'package:tumbas_servis/core/domain/model/workshop/workshop.dart';
import 'package:tumbas_servis/core/presentation/components/empty_state.dart';
import 'package:tumbas_servis/core/presentation/components/error_state.dart';
import 'package:tumbas_servis/core/presentation/components/max_width_box.dart';
import 'package:tumbas_servis/core/presentation/components/skeleton.dart';
import 'package:tumbas_servis/core/presentation/components/ts_app_bar.dart';
import 'package:tumbas_servis/core/presentation/theme/ts_theme_extension.dart';
import 'package:tumbas_servis/core/presentation/utils/window_size_class.dart';
import 'package:tumbas_servis/workshop/presentation/di/workshop_presentation_module.dart';
import 'package:tumbas_servis/workshop/presentation/pilih_bengkel/components/filter_chip_row.dart';
import 'package:tumbas_servis/workshop/presentation/pilih_bengkel/components/search_bar.dart';
import 'package:tumbas_servis/workshop/presentation/pilih_bengkel/components/workshop_detail_pane.dart';
import 'package:tumbas_servis/workshop/presentation/pilih_bengkel/components/workshop_card.dart';
import 'package:tumbas_servis/workshop/presentation/pilih_bengkel/pilih_bengkel_view_model.dart';
import 'package:tumbas_servis/workshop/presentation/pilih_bengkel/state/pilih_bengkel_state.dart';

class PilihBengkelPage extends ConsumerStatefulWidget {
  const PilihBengkelPage({super.key});

  @override
  ConsumerState<PilihBengkelPage> createState() => _PilihBengkelPageState();
}

class _PilihBengkelPageState extends ConsumerState<PilihBengkelPage> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _clearSearch(PilihBengkelViewModel viewModel) {
    _searchController.clear();
    viewModel.setSearchQuery('');
  }

  @override
  Widget build(BuildContext context) {
    final draft = ref.watch(bookingDraftProvider);
    final state = ref.watch(pilihBengkelViewModelProvider);
    final viewModel = ref.read(pilihBengkelViewModelProvider.notifier);
    final scheme = Theme.of(context).colorScheme;
    final ext = TsThemeExtension.of(context);
    final textTheme = Theme.of(context).textTheme;

    final sizeClass = context.windowSizeClass;
    final isSplit = sizeClass.isAtLeast(WindowSizeClass.expanded);

    Widget body;
    if (state.hasError) {
      body = ErrorState(
        message: 'Daftar bengkel gagal dimuat. Coba lagi.',
        onRetry: viewModel.refresh,
        layout: ErrorStateLayout.fullPage,
      );
    } else {
      final visible = viewModel.visibleWorkshops;
      final previewed = isSplit
          ? viewModel.previewedWorkshop(draft?.workshopId)
          : null;
      final hPad = isSplit ? 0.0 : 20.0;

      Future<void> chooseWorkshop(Workshop workshop) async {
        await ref
            .read(bookingDraftProvider.notifier)
            .selectWorkshop(workshop.id);
        if (!context.mounted) return;
        context.push(Routes.bookingSchedule);
      }

      final listColumn = Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(hPad, 4, hPad, 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Satu bengkel untuk semua motor. Jadwal dipilih di langkah '
                'berikutnya.',
                style: textTheme.bodyMedium?.copyWith(color: ext.textMuted),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: hPad),
            child: WorkshopSearchBar(
              controller: _searchController,
              onChanged: viewModel.setSearchQuery,
              onClear: () => _clearSearch(viewModel),
            ),
          ),
          const SizedBox(height: 12),
          FilterChipRow(
            selected: state.filter,
            onSelected: viewModel.setFilter,
            horizontalPadding: hPad,
          ),
          const SizedBox(height: 8),
          if (!state.isLoading)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: hPad),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '${visible.length} bengkel · ${_filterCaption(state.filter)}',
                  style: textTheme.labelMedium?.copyWith(color: ext.textMuted),
                ),
              ),
            ),
          const SizedBox(height: 8),
          Expanded(
            child: state.isLoading
                ? _LoadingList(horizontalPadding: hPad)
                : visible.isEmpty
                ? EmptyState(
                    title: 'Bengkel tidak ditemukan',
                    body: state.searchQuery.trim().isNotEmpty
                        ? 'Tidak ada hasil untuk "${state.searchQuery.trim()}". '
                              'Coba kata kunci lain atau hapus filter.'
                        : 'Coba kata kunci lain atau hapus filter.',
                    ctaLabel: 'Hapus pencarian & filter',
                    onCta: () {
                      _clearSearch(viewModel);
                      viewModel.setFilter(WorkshopFilter.terdekat);
                    },
                  )
                : _WorkshopList(
                    workshops: visible,
                    horizontalPadding: hPad,
                    chosenWorkshopId: draft?.workshopId,
                    previewedWorkshopId: previewed?.id,
                    statusLineFor: viewModel.statusLineFor,
                    estimateLabelFor: (workshop) {
                      final minutes = viewModel.estimateMinFor(workshop, draft);
                      return minutes == null
                          ? null
                          : 'Estimasi ${formatEstimateDuration(minutes)} '
                                'untuk ${draft?.selectedMotorIds.length ?? 0} motor';
                    },
                    onTap: (workshop) => isSplit
                        ? viewModel.previewWorkshop(workshop.id)
                        : context.push(
                            Routes.bookingWorkshopDetail(workshop.id),
                          ),
                  ),
          ),
        ],
      );

      Widget content;
      if (isSplit) {
        final listWidth = sizeClass == WindowSizeClass.large ? 440.0 : 400.0;
        content = MaxWidthBox(
          maxWidth: 1280,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(width: listWidth, child: listColumn),
                const SizedBox(width: 24),
                Expanded(
                  child: previewed == null
                      ? const WorkshopPanePlaceholder()
                      : WorkshopDetailPane(
                          workshopId: previewed.id,
                          chosen: previewed.id == draft?.workshopId,
                          onChoose: chooseWorkshop,
                        ),
                ),
              ],
            ),
          ),
        );
      } else if (sizeClass == WindowSizeClass.medium) {
        content = MaxWidthBox(maxWidth: 720, child: listColumn);
      } else {
        content = listColumn;
      }

      body = Column(
        children: [
          const BookingStepper(currentStep: 3),
          Expanded(child: content),
        ],
      );
    }

    return Scaffold(
      backgroundColor: scheme.surface,
      appBar: TsAppBar.back(title: 'Pilih bengkel'),
      body: SafeArea(top: false, child: body),
    );
  }
}

String _filterCaption(WorkshopFilter filter) => switch (filter) {
  WorkshopFilter.bukaSekarang => 'buka sekarang',
  WorkshopFilter.terdekat => 'urut terdekat',
  WorkshopFilter.ratingTertinggi => 'urut rating tertinggi',
};

class _LoadingList extends StatelessWidget {
  const _LoadingList({required this.horizontalPadding});

  final double horizontalPadding;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 8),
      children: const [
        SkeletonBlock(height: 128),
        SizedBox(height: 8),
        SkeletonBlock(height: 128),
        SizedBox(height: 8),
        SkeletonBlock(height: 128),
        SizedBox(height: 8),
        SkeletonBlock(height: 128),
      ],
    );
  }
}

class _WorkshopList extends StatelessWidget {
  const _WorkshopList({
    required this.workshops,
    required this.horizontalPadding,
    required this.chosenWorkshopId,
    required this.previewedWorkshopId,
    required this.statusLineFor,
    required this.estimateLabelFor,
    required this.onTap,
  });

  final List<Workshop> workshops;
  final double horizontalPadding;
  final String? chosenWorkshopId;
  final String? previewedWorkshopId;
  final String Function(Workshop) statusLineFor;
  final String? Function(Workshop) estimateLabelFor;
  final ValueChanged<Workshop> onTap;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.fromLTRB(horizontalPadding, 0, horizontalPadding, 12),
      itemCount: workshops.length,
      separatorBuilder: (_, _) => const SizedBox(height: 8),
      itemBuilder: (context, index) => _tile(workshops[index]),
    );
  }

  Widget _tile(Workshop workshop) {
    final isPreviewed = workshop.id == previewedWorkshopId;
    final splitMode = previewedWorkshopId != null;
    return WorkshopCard(
      workshop: workshop,
      statusLine: statusLineFor(workshop),
      open: !statusLineFor(workshop).startsWith('Tutup'),
      chosen: workshop.id == chosenWorkshopId,
      previewed: isPreviewed,
      highlighted: splitMode ? isPreviewed : null,
      estimateLabel: estimateLabelFor(workshop),
      onTap: () => onTap(workshop),
    );
  }
}
