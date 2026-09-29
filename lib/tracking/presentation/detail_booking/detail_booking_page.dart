import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tumbas_servis/app/navigation/routes.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking_status.dart';
import 'package:tumbas_servis/core/presentation/components/error_state.dart';
import 'package:tumbas_servis/core/presentation/components/fleet_progress.dart';
import 'package:tumbas_servis/core/presentation/components/skeleton.dart';
import 'package:tumbas_servis/core/presentation/components/ts_app_bar.dart';
import 'package:tumbas_servis/core/presentation/components/ts_button.dart';
import 'package:tumbas_servis/core/presentation/components/ts_snackbar.dart';
import 'package:tumbas_servis/core/presentation/theme/ts_theme_extension.dart';
import 'package:tumbas_servis/core/presentation/utils/date_formatter.dart';
import 'package:tumbas_servis/tracking/presentation/components/booking_status_badge.dart';
import 'package:tumbas_servis/tracking/presentation/detail_booking/components/unit_status_row.dart';
import 'package:tumbas_servis/tracking/presentation/detail_booking/state/detail_booking_state.dart';
import 'package:tumbas_servis/tracking/presentation/di/tracking_presentation_module.dart';
import 'package:tumbas_servis/tracking/presentation/ubah_jadwal_batalkan/batalkan_dialog.dart';
import 'package:tumbas_servis/tracking/presentation/ubah_jadwal_batalkan/ubah_jadwal_sheet.dart';
import 'package:tumbas_servis/tracking/presentation/utils/tracking_display.dart';

class DetailBookingPage extends ConsumerWidget {
  const DetailBookingPage({required this.bookingId, super.key});

  final String bookingId;

  void _goBack(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(Routes.bookings);
    }
  }

  Future<void> _reschedule(
    BuildContext context,
    WidgetRef ref,
    DetailBookingState state,
  ) async {
    final booking = state.booking!;
    final saved = await showUbahJadwalSheet(
      context,
      args: (
        booking: booking,
        workshopName: state.workshopName,
        bayCount: state.bayCount,
      ),
    );
    if (!saved || !context.mounted) return;
    await ref
        .read(detailBookingViewModelProvider(bookingId).notifier)
        .refresh();
    if (context.mounted) TsSnackbar.success(context, 'Jadwal diperbarui');
  }

  Future<void> _cancel(
    BuildContext context,
    WidgetRef ref,
    DetailBookingState state,
  ) async {
    final choice = await showBatalkanDialog(
      context,
      booking: state.booking!,
      canCancelWhole: state.canCancelWhole,
    );
    if (choice == null || !context.mounted) return;
    final ok = await ref
        .read(detailBookingViewModelProvider(bookingId).notifier)
        .cancel(unitCode: choice.unitCode, reason: choice.reason);
    if (!context.mounted) return;
    if (ok) {
      TsSnackbar.success(
        context,
        choice.unitCode == null
            ? 'Booking dibatalkan'
            : 'Unit ${choice.unitCode} dibatalkan',
      );
    } else {
      TsSnackbar.error(context, 'Gagal membatalkan. Coba lagi.');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = detailBookingViewModelProvider(bookingId);
    final state = ref.watch(provider);
    final viewModel = ref.read(provider.notifier);
    final scheme = Theme.of(context).colorScheme;
    final booking = state.booking;

    return Scaffold(
      backgroundColor: scheme.surface,
      appBar: TsAppBar.back(
        title: 'Detail booking',
        onBack: () => _goBack(context),
      ),
      body: SafeArea(
        top: false,
        child: state.hasError
            ? ErrorState(
                message: 'Gagal memuat detail booking. Coba lagi.',
                onRetry: viewModel.retry,
                layout: ErrorStateLayout.fullPage,
              )
            : state.isLoading || booking == null
            ? const _DetailSkeleton()
            : RefreshIndicator(
                onRefresh: viewModel.refresh,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 720),
                      child: _DetailContent(
                        state: state,
                        booking: booking,
                        onReschedule: () => _reschedule(context, ref, state),
                        onCancel: () => _cancel(context, ref, state),
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}

class _DetailContent extends StatelessWidget {
  const _DetailContent({
    required this.state,
    required this.booking,
    required this.onReschedule,
    required this.onCancel,
  });

  final DetailBookingState state;
  final Booking booking;
  final VoidCallback onReschedule;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final ext = TsThemeExtension.of(context);
    final textTheme = Theme.of(context).textTheme;
    final cancelled = booking.status == BookingStatus.dibatalkan;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _HeaderCard(state: state, booking: booking),
        if (!cancelled) ...[
          const SizedBox(height: 16),
          FleetProgress(
            unitStatuses: [for (final u in booking.units) u.status],
            label:
                'Progres ${booking.units.length} motor: '
                '${booking.status.label}',
            legendLabels: [
              for (final u in booking.units)
                '${unitLetter(u.unitCode)} · ${u.status.timelineLabel}',
            ],
          ),
        ],
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
          decoration: BoxDecoration(
            color: scheme.surfaceContainer,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Status motor',
                style: textTheme.titleMedium?.copyWith(color: scheme.onSurface),
              ),
              const SizedBox(height: 4),
              for (var i = 0; i < booking.units.length; i++)
                UnitStatusRow(
                  unit: booking.units[i],
                  meta:
                      state.unitMeta[booking.units[i].unitCode] ??
                      'Unit ${booking.units[i].unitCode}',
                  showDivider: i < booking.units.length - 1,
                  onTap: () => context.push(
                    Routes.bookingUnitDetail(
                      booking.id,
                      booking.units[i].unitCode,
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        if (state.showScheduleActions) ...[
          _ActionButton(
            label: 'Ubah jadwal',
            icon: Icons.edit_calendar_rounded,
            onPressed: state.canReschedule ? onReschedule : null,
            reason: state.rescheduleDisabledReason,
          ),
          const SizedBox(height: 12),
          _ActionButton(
            label: 'Batalkan',
            icon: Icons.event_busy_rounded,
            type: TsButtonType.dangerOutline,
            onPressed: state.canCancel ? onCancel : null,
            reason: state.cancelDisabledReason,
          ),
        ],
        if (booking.status == BookingStatus.selesai) ...[
          _ActionButton(
            label: 'Lihat invoice',
            icon: Icons.receipt_long_rounded,
            onPressed: () => context.push(Routes.invoice(booking.id)),
          ),
          const SizedBox(height: 12),
          if (state.hasReview)
            _ActionButton(
              label: 'Lihat ulasan',
              icon: Icons.star_rounded,
              onPressed: () => context.push(Routes.review(booking.id)),
            )
          else
            _ActionButton(
              label: 'Beri ulasan',
              icon: Icons.star_border_rounded,
              onPressed: state.canReview
                  ? () => context.push(Routes.review(booking.id))
                  : null,
              reason: state.canReview ? null : DetailBookingState.unpaidReview,
            ),
        ],
        if (cancelled && state.cancelledAt != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              'Dibatalkan ${DateFormatter.format(state.cancelledAt!).split(', ').last}',
              style: textTheme.bodyMedium?.copyWith(color: ext.textMuted),
            ),
          ),
        if (booking.status == BookingStatus.selesai ||
            booking.status == BookingStatus.dibatalkan) ...[
          if (booking.status == BookingStatus.selesai)
            const SizedBox(height: 12),
          TsButton(
            label: 'Booking lagi',
            type: cancelled ? TsButtonType.outline : TsButtonType.ghost,
            leadingIcon: Icons.refresh_rounded,
            onPressed: () => context.push(
              Routes.bookingVehicles,
              extra: [for (final u in booking.units) u.motorId],
            ),
          ),
        ],
      ],
    );
  }
}

class _HeaderCard extends StatelessWidget {
  const _HeaderCard({required this.state, required this.booking});

  final DetailBookingState state;
  final Booking booking;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final ext = TsThemeExtension.of(context);
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  booking.code,
                  style: textTheme.titleLarge?.copyWith(
                    color: scheme.onSurface,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              BookingStatusBadge(status: booking.status),
            ],
          ),
          const SizedBox(height: 12),
          Semantics(
            button: true,
            label:
                'Bengkel ${state.workshopName}, ${state.bayCount} bay servis',
            excludeSemantics: true,
            child: InkWell(
              onTap: () =>
                  context.push(Routes.workshopDetail(booking.workshopId)),
              borderRadius: BorderRadius.circular(16),
              child: Container(
                constraints: const BoxConstraints(minHeight: 48),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: scheme.outline),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: scheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.storefront_rounded,
                        size: 20,
                        color: ext.textBody,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            state.workshopName,
                            style: textTheme.titleSmall?.copyWith(
                              color: scheme.onSurface,
                            ),
                          ),
                          Text(
                            '${state.bayCount} bay servis',
                            style: textTheme.bodySmall?.copyWith(
                              color: ext.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.chevron_right_rounded, color: ext.textMuted),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.event_rounded, size: 20, color: ext.textMuted),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  bookingScheduleLine(booking),
                  style: textTheme.bodyMedium?.copyWith(
                    color: scheme.onSurface,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.icon,
    required this.onPressed,
    this.type = TsButtonType.outline,
    this.reason,
  });

  final String label;
  final IconData icon;
  final VoidCallback? onPressed;
  final TsButtonType type;
  final String? reason;

  @override
  Widget build(BuildContext context) {
    final ext = TsThemeExtension.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TsButton(
          label: label,
          type: type,
          leadingIcon: icon,
          onPressed: onPressed,
        ),
        if (reason != null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              reason!,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: ext.textMuted),
            ),
          ),
      ],
    );
  }
}

class _DetailSkeleton extends StatelessWidget {
  const _DetailSkeleton();

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Memuat detail booking',
      child: const SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.fromLTRB(20, 16, 20, 32),
        child: Column(
          children: [
            SkeletonBlock(height: 184),
            SizedBox(height: 16),
            SkeletonBlock(height: 28),
            SizedBox(height: 16),
            SkeletonBlock(height: 264),
            SizedBox(height: 16),
            SkeletonBlock(height: 48),
          ],
        ),
      ),
    );
  }
}
