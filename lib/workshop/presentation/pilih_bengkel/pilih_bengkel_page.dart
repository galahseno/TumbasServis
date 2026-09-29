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
import 'package:tumbas_servis/core/presentation/components/skeleton.dart';
import 'package:tumbas_servis/core/presentation/components/ts_app_bar.dart';
import 'package:tumbas_servis/core/presentation/theme/ts_theme_extension.dart';
import 'package:tumbas_servis/workshop/presentation/di/workshop_presentation_module.dart';
import 'package:tumbas_servis/workshop/presentation/pilih_bengkel/components/filter_chip_row.dart';
import 'package:tumbas_servis/workshop/presentation/pilih_bengkel/components/search_bar.dart';
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

    Widget body;
    if (state.hasError) {
      body = ErrorState(
        message: 'Daftar bengkel gagal dimuat. Coba lagi.',
        onRetry: viewModel.refresh,
        layout: ErrorStateLayout.fullPage,
      );
    } else {
      final visible = viewModel.visibleWorkshops;
      body = Column(
        children: [
          BookingStepper(currentStep: 3),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
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
            padding: const EdgeInsets.symmetric(horizontal: 20),
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
          ),
          const SizedBox(height: 8),
          if (!state.isLoading)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
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
                ? const _LoadingList()
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
                    chosenWorkshopId: draft?.workshopId,
                    statusLineFor: viewModel.statusLineFor,
                    estimateLabelFor: (workshop) {
                      final minutes = viewModel.estimateMinFor(workshop, draft);
                      return minutes == null
                          ? null
                          : 'Estimasi ${formatEstimateDuration(minutes)} '
                                'untuk ${draft?.selectedMotorIds.length ?? 0} motor';
                    },
                    onTap: (workshop) =>
                        context.push(Routes.bookingWorkshopDetail(workshop.id)),
                  ),
          ),
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
  const _LoadingList();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
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
    required this.chosenWorkshopId,
    required this.statusLineFor,
    required this.estimateLabelFor,
    required this.onTap,
  });

  final List<Workshop> workshops;
  final String? chosenWorkshopId;
  final String Function(Workshop) statusLineFor;
  final String? Function(Workshop) estimateLabelFor;
  final ValueChanged<Workshop> onTap;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 1024
            ? 2
            : constraints.maxWidth >= 600
            ? 2
            : 1;
        if (columns == 1) {
          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
            itemCount: workshops.length,
            separatorBuilder: (_, _) => const SizedBox(height: 8),
            itemBuilder: (context, index) => _tile(workshops[index]),
          );
        }
        return GridView.builder(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            mainAxisSpacing: 8,
            crossAxisSpacing: 12,
            mainAxisExtent: 140,
          ),
          itemCount: workshops.length,
          itemBuilder: (context, index) => _tile(workshops[index]),
        );
      },
    );
  }

  Widget _tile(Workshop workshop) {
    return WorkshopCard(
      workshop: workshop,
      statusLine: statusLineFor(workshop),
      open: !statusLineFor(workshop).startsWith('Tutup'),
      chosen: workshop.id == chosenWorkshopId,
      estimateLabel: estimateLabelFor(workshop),
      onTap: () => onTap(workshop),
    );
  }
}
