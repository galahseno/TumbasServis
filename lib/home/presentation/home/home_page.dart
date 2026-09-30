import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tumbas_servis/core/presentation/utils/window_size_class.dart';
import 'package:tumbas_servis/app/navigation/garage_result.dart';
import 'package:tumbas_servis/app/navigation/routes.dart';
import 'package:tumbas_servis/core/presentation/components/error_state.dart';
import 'package:tumbas_servis/core/presentation/components/max_width_box.dart';
import 'package:tumbas_servis/core/presentation/components/section_title_row.dart';
import 'package:tumbas_servis/core/presentation/components/skeleton.dart';
import 'package:tumbas_servis/core/presentation/components/ts_app_bar.dart';
import 'package:tumbas_servis/core/presentation/components/ts_dialog.dart';
import 'package:tumbas_servis/core/presentation/components/ts_snackbar.dart';
import 'package:tumbas_servis/core/presentation/components/vehicle_select_card.dart';
import 'package:tumbas_servis/home/presentation/di/home_presentation_module.dart';
import 'package:tumbas_servis/home/presentation/home/home_view_model.dart';
import 'package:tumbas_servis/home/presentation/home/state/home_state.dart';
import 'package:tumbas_servis/home/presentation/home/components/active_booking_card.dart';
import 'package:tumbas_servis/home/presentation/home/components/booking_cta_card.dart';
import 'package:tumbas_servis/home/presentation/home/components/draft_resume_card.dart';
import 'package:tumbas_servis/home/presentation/home/components/garage_add_tile.dart';
import 'package:tumbas_servis/home/presentation/home/components/home_loading_progress.dart';
import 'package:tumbas_servis/home/presentation/home/components/promo_carousel.dart';
import 'package:tumbas_servis/home/presentation/home/components/quick_link_tile.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  static const _tabletMaxContentWidth = 1040.0 - 48;
  static const _tabletTwoUpMinWidth = 900.0;
  static const _garageMaxSlots = 5;
  static const _garageMinSlotWidth = 116.0;
  static const _garageGap = 12.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeViewModelProvider);
    final viewModel = ref.read(homeViewModelProvider.notifier);
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isTablet = !context.windowSizeClass.isCompact;
    final greeting = 'Halo, ${state.isLoading ? '...' : state.userName} 👋';

    return Scaffold(
      backgroundColor: scheme.surface,
      appBar: isTablet
          ? TsAppBar(
              title: greeting,
              bellUnreadCount: state.isLoading ? null : state.unreadCount,
              onBellPressed: () => context.push(Routes.notifications),
            )
          : TsAppBar.home(
              bellUnreadCount: state.isLoading ? null : state.unreadCount,
              onBellPressed: () => context.push(Routes.notifications),
            ),
      body: SafeArea(
        top: false,
        child: state.hasError
            ? ErrorState(
                message: 'Gagal memuat Beranda. Coba lagi.',
                onRetry: viewModel.refresh,
                layout: ErrorStateLayout.fullPage,
              )
            : RefreshIndicator(
                onRefresh: viewModel.refresh,
                child: isTablet
                    ? ListView(
                        padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
                        children: [
                          MaxWidthBox(
                            maxWidth: _tabletMaxContentWidth,
                            child: LayoutBuilder(
                              builder: (context, constraints) => _tabletContent(
                                context,
                                state,
                                viewModel,
                                constraints.maxWidth,
                              ),
                            ),
                          ),
                        ],
                      )
                    : ListView(
                        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
                        children: [
                          Text(
                            greeting,
                            style: textTheme.headlineSmall?.copyWith(
                              color: scheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 16),
                          if (state.isLoading) ...[
                            if (state.isFirstLoad) ...[
                              HomeLoadingProgress(
                                progress: state.loadProgress,
                                label: state.loadLabel,
                              ),
                              const SizedBox(height: 16),
                            ],
                            const SkeletonBlock(height: 148),
                            const SizedBox(height: 16),
                            const SkeletonBlock(height: 160),
                            const SizedBox(height: 16),
                            const SkeletonBlock(height: 148),
                            const SizedBox(height: 16),
                            const SkeletonBlock(height: 148),
                          ] else ...[
                            _ctaCard(context, state),
                            ..._activeBookingList(context, state, viewModel),
                            if (state.draft != null) ...[
                              const SizedBox(height: 16),
                              _draftCard(context, state, viewModel),
                            ],
                            if (state.promos.isNotEmpty) ...[
                              const SizedBox(height: 16),
                              _promoCarousel(context, state),
                            ],
                            const SizedBox(height: 24),
                            _garageHeader(context),
                            const SizedBox(height: 12),
                            SizedBox(
                              height: _garageStripHeight(context),
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemCount: state.motors.length + 1,
                                separatorBuilder: (_, _) =>
                                    const SizedBox(width: 12),
                                itemBuilder: (context, index) => _garageItem(
                                  context,
                                  state,
                                  viewModel,
                                  index,
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            SizedBox(
                              width: double.infinity,
                              child: _catalogTile(context),
                            ),
                          ],
                        ],
                      ),
              ),
      ),
    );
  }

  double _garageStripHeight(BuildContext context) {
    final factor = MediaQuery.textScalerOf(context).scale(1);
    return 168 + (factor.clamp(1.0, 2.0) - 1) * 80;
  }

  Widget _ctaCard(
    BuildContext context,
    HomeState state, {
    bool hugButton = false,
  }) => BookingCtaCard(
    hugButton: hugButton,
    variant: state.isEmpty
        ? BookingCtaCardVariant.hero
        : BookingCtaCardVariant.compact,
    onPressed: () => context.push(Routes.bookingVehicles),
  );

  List<Widget> _activeBookingList(
    BuildContext context,
    HomeState state,
    HomeViewModel viewModel,
  ) {
    if (state.activeBookings.isEmpty) return const [];
    return [
      const SizedBox(height: 16),
      for (final display in state.activeBookings) ...[
        ActiveBookingCard(
          display: display,
          onTap: () async {
            await context.push(Routes.bookingDetail(display.booking.id));
            viewModel.refresh();
          },
        ),
        const SizedBox(height: 8),
      ],
      if (state.activeBookingsTotalCount > 2)
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () => context.go(Routes.bookings),
            child: Text('Lihat semua (${state.activeBookingsTotalCount})'),
          ),
        ),
    ];
  }

  Widget _draftCard(
    BuildContext context,
    HomeState state,
    HomeViewModel viewModel,
  ) => DraftResumeCard(
    display: state.draft!,
    onResume: () => context.push(Routes.bookingVehicles),
    onDelete: () => _confirmDeleteDraft(context, viewModel.deleteDraft),
  );

  Widget _promoCarousel(
    BuildContext context,
    HomeState state, {
    int perView = 1,
  }) => PromoCarousel(
    promos: state.promos,
    perView: perView,
    onTapPromo: (promo) => context.push(Routes.bookingVehicles),
  );

  Widget _garageHeader(BuildContext context) => SectionTitleRow(
    title: 'Garasi saya',
    onSeeAll: () => context.go(Routes.garage),
    seeAllSemanticLabel: 'Lihat semua motor',
  );

  Widget _garageItem(
    BuildContext context,
    HomeState state,
    HomeViewModel viewModel,
    int index, {
    double width = 124,
  }) {
    if (index == state.motors.length) {
      return GarageAddTile(
        width: width,
        onTap: () => _openGarage(context, viewModel, Routes.garageAdd),
      );
    }
    final motor = state.motors[index];
    return VehicleSelectCard(
      width: width,
      nickname: motor.nickname,
      plateNumber: motor.plateNumber,
      inServiceStatus: state.motorInServiceStatus[motor.id],
      onTap: () =>
          _openGarage(context, viewModel, Routes.garageDetail(motor.id)),
    );
  }

  Widget _catalogTile(BuildContext context) => QuickLinkTile(
    icon: Icons.oil_barrel_rounded,
    label: 'Katalog suku cadang',
    onTap: () => context.push(Routes.catalog),
  );

  Widget _tabletContent(
    BuildContext context,
    HomeState state,
    HomeViewModel viewModel,
    double width,
  ) {
    const gap = 16.0;
    if (state.isLoading) {
      return Column(
        children: [
          if (state.isFirstLoad) ...[
            HomeLoadingProgress(
              progress: state.loadProgress,
              label: state.loadLabel,
            ),
            const SizedBox(height: gap),
          ],
          const SkeletonBlock(height: 148),
          const SizedBox(height: gap),
          const Row(
            children: [
              Expanded(child: SkeletonBlock(height: 160)),
              SizedBox(width: gap),
              Expanded(child: SkeletonBlock(height: 160)),
            ],
          ),
          const SizedBox(height: gap),
          const SkeletonBlock(height: 148),
          const SizedBox(height: gap),
          SkeletonBlock(height: _garageStripHeight(context)),
        ],
      );
    }

    final hasActive = state.activeBookings.isNotEmpty;
    final hasDraft = state.draft != null;
    final activeColumn = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final display in state.activeBookings) ...[
          ActiveBookingCard(
            display: display,
            onTap: () async {
              await context.push(Routes.bookingDetail(display.booking.id));
              viewModel.refresh();
            },
          ),
          const SizedBox(height: 8),
        ],
        if (state.activeBookingsTotalCount > 2)
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => context.go(Routes.bookings),
              child: Text('Lihat semua (${state.activeBookingsTotalCount})'),
            ),
          ),
      ],
    );

    final slots = ((width + _garageGap) / (_garageMinSlotWidth + _garageGap))
        .floor()
        .clamp(3, _garageMaxSlots);
    final slotWidth = (width - _garageGap * (slots - 1)) / slots;
    final twoUp = width >= _tabletTwoUpMinWidth;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _ctaCard(context, state, hugButton: true),
        if (hasActive || hasDraft) ...[
          const SizedBox(height: gap),
          if (hasActive && hasDraft)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: activeColumn),
                const SizedBox(width: gap),
                Expanded(child: _draftCard(context, state, viewModel)),
              ],
            )
          else if (hasActive)
            activeColumn
          else
            _draftCard(context, state, viewModel),
        ],
        if (state.promos.isNotEmpty) ...[
          const SizedBox(height: gap),
          _promoCarousel(context, state, perView: twoUp ? 2 : 1),
        ],
        const SizedBox(height: 24),
        _garageHeader(context),
        const SizedBox(height: 12),
        SizedBox(
          height: _garageStripHeight(context),
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: state.motors.length + 1,
            separatorBuilder: (_, _) => const SizedBox(width: _garageGap),
            itemBuilder: (context, index) =>
                _garageItem(context, state, viewModel, index, width: slotWidth),
          ),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: QuickLinkTile(
                icon: Icons.history_rounded,
                label: 'Riwayat',
                onTap: () => context.go(Routes.bookings),
              ),
            ),
            const SizedBox(width: gap),
            Expanded(child: _catalogTile(context)),
          ],
        ),
      ],
    );
  }

  Future<void> _openGarage(
    BuildContext context,
    HomeViewModel viewModel,
    String route,
  ) async {
    final result = await context.push<GarageMotorResult>(route);
    if (!context.mounted) return;
    await viewModel.refresh();
    if (!context.mounted) return;
    final message = switch (result) {
      GarageMotorResult.created => 'Motor ditambahkan',
      GarageMotorResult.updated => 'Perubahan disimpan',
      GarageMotorResult.deleted => 'Motor dihapus',
      null => null,
    };
    if (message != null) {
      TsSnackbar.success(
        context,
        message,
        aboveNavBar: context.windowSizeClass.isCompact,
      );
    }
  }

  Future<void> _confirmDeleteDraft(
    BuildContext context,
    Future<void> Function() onConfirm,
  ) async {
    final confirmed = await TsDialog.confirmDestructive(
      context,
      title: 'Hapus draft booking?',
      message: 'Draft booking ini akan dihapus dan tidak bisa dikembalikan.',
      confirmLabel: 'Hapus draft',
    );
    if (confirmed ?? false) await onConfirm();
  }
}
