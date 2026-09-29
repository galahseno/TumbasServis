import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tumbas_servis/app/navigation/routes.dart';
import 'package:tumbas_servis/core/presentation/components/empty_state.dart';
import 'package:tumbas_servis/core/presentation/components/error_state.dart';
import 'package:tumbas_servis/core/presentation/components/skeleton.dart';
import 'package:tumbas_servis/core/presentation/components/ts_app_bar.dart';
import 'package:tumbas_servis/core/presentation/theme/ts_theme_extension.dart';
import 'package:tumbas_servis/tracking/presentation/di/tracking_presentation_module.dart';
import 'package:tumbas_servis/tracking/presentation/riwayat/components/booking_history_card.dart';
import 'package:tumbas_servis/tracking/presentation/riwayat/components/history_tab_row.dart';
import 'package:tumbas_servis/tracking/presentation/riwayat/state/riwayat_state.dart';

class RiwayatPage extends ConsumerWidget {
  const RiwayatPage({super.key, this.motorFilterId});

  final String? motorFilterId;

  Future<void> _openDetail(
    BuildContext context,
    WidgetRef ref,
    String bookingId,
  ) async {
    await context.push(Routes.bookingDetail(bookingId));
    ref.read(riwayatViewModelProvider(motorFilterId).notifier).refresh();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = riwayatViewModelProvider(motorFilterId);
    final state = ref.watch(provider);
    final viewModel = ref.read(provider.notifier);
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: scheme.surface,
      appBar: motorFilterId == null
          ? TsAppBar.large('Riwayat')
          : TsAppBar.back(title: 'Riwayat servis'),
      body: SafeArea(
        top: false,
        child: state.hasError
            ? ErrorState(
                message: 'Gagal memuat riwayat booking. Coba lagi.',
                onRetry: viewModel.retry,
                layout: ErrorStateLayout.fullPage,
              )
            : state.isLoading
            ? const _RiwayatSkeleton()
            : Column(
                children: [
                  HistoryTabRow(
                    selected: state.selectedTab,
                    countFor: state.countFor,
                    onSelected: viewModel.selectTab,
                  ),
                  if (state.motorFilterId != null &&
                      state.motorFilterLabel != null)
                    _MotorFilterChip(
                      label: state.motorFilterLabel!,
                      onDismiss: viewModel.clearMotorFilter,
                    ),
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: viewModel.refresh,
                      child: _RiwayatList(
                        state: state,
                        onOpen: (id) => _openDetail(context, ref, id),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class _RiwayatList extends StatelessWidget {
  const _RiwayatList({required this.state, required this.onOpen});

  final RiwayatState state;
  final ValueChanged<String> onOpen;

  @override
  Widget build(BuildContext context) {
    final entries = state.visibleEntries;
    if (entries.isEmpty) {
      final tab = state.selectedTab;
      return LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Center(
              child: EmptyState(
                icon: Icons.history_rounded,
                title: _emptyTitle(tab),
                body: _emptyBody(tab),
                // No CTA on Dibatalkan: nothing to "do" there (design note).
                ctaLabel: tab == RiwayatTab.dibatalkan
                    ? null
                    : 'Booking servis',
                onCta: tab == RiwayatTab.dibatalkan
                    ? null
                    : () => context.push(Routes.bookingVehicles),
              ),
            ),
          ),
        ),
      );
    }

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 720),
        child: ListView.separated(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          itemCount: entries.length,
          separatorBuilder: (_, _) => const SizedBox(height: 12),
          itemBuilder: (context, index) => BookingHistoryCard(
            entry: entries[index],
            onTap: () => onOpen(entries[index].booking.id),
          ),
        ),
      ),
    );
  }

  static String _emptyTitle(RiwayatTab tab) => switch (tab) {
    RiwayatTab.mendatang => 'Belum ada booking mendatang',
    RiwayatTab.berlangsung => 'Tidak ada servis berlangsung',
    RiwayatTab.selesai => 'Belum ada servis selesai',
    RiwayatTab.dibatalkan => 'Tidak ada booking dibatalkan',
  };

  static String _emptyBody(RiwayatTab tab) => switch (tab) {
    RiwayatTab.mendatang => 'Booking yang sudah dijadwalkan muncul di sini.',
    RiwayatTab.berlangsung => 'Motor yang sedang diservis muncul di sini.',
    RiwayatTab.selesai => 'Riwayat servis yang sudah selesai muncul di sini.',
    RiwayatTab.dibatalkan => 'Booking yang kamu batalkan muncul di sini.',
  };
}

class _MotorFilterChip extends StatelessWidget {
  const _MotorFilterChip({required this.label, required this.onDismiss});

  final String label;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final ext = TsThemeExtension.of(context);
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
        child: Semantics(
          button: true,
          label: 'Filter motor $label, ketuk untuk hapus',
          excludeSemantics: true,
          child: InkWell(
            onTap: onDismiss,
            borderRadius: BorderRadius.circular(999),
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 48),
              child: Container(
                padding: const EdgeInsets.only(left: 14, right: 8),
                decoration: BoxDecoration(
                  color: scheme.primaryContainer,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: ext.borderAccent),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.two_wheeler_rounded,
                      size: 16,
                      color: scheme.onPrimaryContainer,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      label,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: scheme.onPrimaryContainer,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.close_rounded,
                      size: 18,
                      color: scheme.onPrimaryContainer,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RiwayatSkeleton extends StatelessWidget {
  const _RiwayatSkeleton();

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Memuat riwayat',
      child: const SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.fromLTRB(20, 16, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(flex: 4, child: SkeletonLine(height: 16)),
                SizedBox(width: 24),
                Expanded(flex: 4, child: SkeletonLine(height: 16)),
                SizedBox(width: 24),
                Expanded(flex: 3, child: SkeletonLine(height: 16)),
              ],
            ),
            SizedBox(height: 24),
            SkeletonBlock(height: 116),
            SizedBox(height: 12),
            SkeletonBlock(height: 116),
            SizedBox(height: 12),
            SkeletonBlock(height: 116),
          ],
        ),
      ),
    );
  }
}
