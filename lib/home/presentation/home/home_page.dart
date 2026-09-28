import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tumbas_servis/app/navigation/routes.dart';
import 'package:tumbas_servis/core/presentation/components/error_state.dart';
import 'package:tumbas_servis/core/presentation/components/skeleton.dart';
import 'package:tumbas_servis/core/presentation/components/ts_app_bar.dart';
import 'package:tumbas_servis/core/presentation/components/ts_dialog.dart';
import 'package:tumbas_servis/core/presentation/components/vehicle_select_card.dart';
import 'package:tumbas_servis/home/presentation/di/home_presentation_module.dart';
import 'package:tumbas_servis/home/presentation/home/components/active_booking_card.dart';
import 'package:tumbas_servis/home/presentation/home/components/booking_cta_card.dart';
import 'package:tumbas_servis/home/presentation/home/components/draft_resume_card.dart';
import 'package:tumbas_servis/home/presentation/home/components/garage_add_tile.dart';
import 'package:tumbas_servis/home/presentation/home/components/promo_carousel.dart';
import 'package:tumbas_servis/home/presentation/home/components/quick_link_tile.dart';
import 'package:tumbas_servis/home/presentation/home/components/section_title_row.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeViewModelProvider);
    final viewModel = ref.read(homeViewModelProvider.notifier);
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: scheme.surface,
      appBar: TsAppBar.home(
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
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
                  children: [
                    Text(
                      'Halo, ${state.isLoading ? '...' : state.userName} 👋',
                      style: textTheme.headlineSmall?.copyWith(
                        color: scheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (state.isLoading) ...[
                      const SkeletonBlock(height: 148),
                      const SizedBox(height: 16),
                      const SkeletonBlock(height: 160),
                      const SizedBox(height: 16),
                      const SkeletonBlock(height: 148),
                      const SizedBox(height: 16),
                      const SkeletonBlock(height: 148),
                    ] else ...[
                      BookingCtaCard(
                        variant: state.isEmpty
                            ? BookingCtaCardVariant.hero
                            : BookingCtaCardVariant.compact,
                        onPressed: () => context.push(Routes.bookingVehicles),
                      ),
                      if (state.activeBookings.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        for (final display in state.activeBookings) ...[
                          ActiveBookingCard(
                            display: display,
                            onTap: () => context.push(
                              Routes.bookingDetail(display.booking.id),
                            ),
                          ),
                          const SizedBox(height: 8),
                        ],
                        if (state.activeBookingsTotalCount > 2)
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () => context.push(Routes.bookings),
                              child: Text(
                                'Lihat semua (${state.activeBookingsTotalCount})',
                              ),
                            ),
                          ),
                      ],
                      if (state.draft != null) ...[
                        const SizedBox(height: 16),
                        DraftResumeCard(
                          display: state.draft!,
                          onResume: () => context.push(Routes.bookingVehicles),
                          onDelete: () => _confirmDeleteDraft(
                            context,
                            viewModel.deleteDraft,
                          ),
                        ),
                      ],
                      if (state.promos.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        PromoCarousel(
                          promos: state.promos,
                          onTapPromo: (promo) =>
                              context.push(Routes.bookingVehicles),
                        ),
                      ],
                      const SizedBox(height: 24),
                      SectionTitleRow(
                        title: 'Garasi saya',
                        onSeeAll: () => context.push(Routes.garage),
                        seeAllSemanticLabel: 'Lihat semua motor',
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 168,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: state.motors.length + 1,
                          separatorBuilder: (_, _) => const SizedBox(width: 12),
                          itemBuilder: (context, index) {
                            if (index == state.motors.length) {
                              return GarageAddTile(
                                onTap: () => context.push(Routes.garageAdd),
                              );
                            }
                            final motor = state.motors[index];
                            return VehicleSelectCard(
                              nickname: motor.nickname,
                              plateNumber: motor.plateNumber,
                              inServiceStatus:
                                  state.motorInServiceStatus[motor.id],
                              onTap: () =>
                                  context.push(Routes.garageDetail(motor.id)),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: QuickLinkTile(
                          icon: Icons.oil_barrel_rounded,
                          label: 'Katalog suku cadang',
                          onTap: () => context.push(Routes.catalog),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
      ),
    );
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
