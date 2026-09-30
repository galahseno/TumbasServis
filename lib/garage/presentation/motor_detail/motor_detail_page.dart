import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tumbas_servis/core/presentation/utils/window_size_class.dart';
import 'package:tumbas_servis/app/navigation/routes.dart';
import 'package:tumbas_servis/core/domain/model/garage/motor.dart';
import 'package:tumbas_servis/core/presentation/components/error_state.dart';
import 'package:tumbas_servis/core/presentation/components/section_title_row.dart';
import 'package:tumbas_servis/core/presentation/components/skeleton.dart';
import 'package:tumbas_servis/core/presentation/components/ts_app_bar.dart';
import 'package:tumbas_servis/core/presentation/components/ts_button.dart';
import 'package:tumbas_servis/core/presentation/components/ts_icon_button.dart';
import 'package:tumbas_servis/core/presentation/components/ts_snackbar.dart';
import 'package:tumbas_servis/core/presentation/theme/ts_theme_extension.dart';
import 'package:tumbas_servis/garage/presentation/di/garage_presentation_module.dart';
import 'package:tumbas_servis/app/navigation/garage_result.dart';
import 'package:tumbas_servis/garage/presentation/motor_detail/components/motor_delete_dialogs.dart';
import 'package:tumbas_servis/garage/presentation/motor_detail/components/motor_details_card.dart';
import 'package:tumbas_servis/garage/presentation/motor_detail/components/motor_hero.dart';
import 'package:tumbas_servis/garage/presentation/motor_detail/components/service_history_row.dart';
import 'package:tumbas_servis/garage/presentation/motor_detail/state/motor_detail_state.dart';

class MotorDetailPage extends ConsumerStatefulWidget {
  const MotorDetailPage({required this.motorId, super.key});

  final String motorId;

  @override
  ConsumerState<MotorDetailPage> createState() => _MotorDetailPageState();
}

class _MotorDetailPageState extends ConsumerState<MotorDetailPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref
          .read(motorDetailViewModelProvider.notifier)
          .initialize(widget.motorId);
    });
  }

  Future<void> _handleEdit(Motor motor) async {
    final result = await context.push<GarageMotorResult>(
      Routes.garageAdd,
      extra: motor,
    );
    if (!mounted) return;
    if (result == GarageMotorResult.updated) {
      await ref.read(motorDetailViewModelProvider.notifier).reload();
      if (!mounted) return;
      TsSnackbar.success(context, 'Perubahan disimpan');
    }
  }

  Future<void> _handleDelete(MotorDetailState state) async {
    final motor = state.motor;
    if (motor == null) return;

    if (state.hasActiveBooking) {
      final viewBooking = await showMotorDeleteBlockedDialog(
        context,
        nickname: motor.nickname,
        plateNumber: motor.plateNumber,
        bookingCode: state.activeEntry!.bookingCode,
      );
      if (viewBooking && mounted) {
        await context.push(Routes.bookingDetail(state.activeEntry!.bookingId));
      }
      return;
    }

    final confirmed = await showDeleteMotorDialog(
      context,
      nickname: motor.nickname,
    );
    if (!confirmed || !mounted) return;

    final deleted = await ref
        .read(motorDetailViewModelProvider.notifier)
        .deleteMotor();
    if (!mounted) return;
    if (deleted) {
      ref.invalidate(garasiViewModelProvider);
      context.pop(GarageMotorResult.deleted);
    } else {
      TsSnackbar.error(context, 'Gagal menghapus motor. Coba lagi.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(motorDetailViewModelProvider);
    final viewModel = ref.read(motorDetailViewModelProvider.notifier);
    final scheme = Theme.of(context).colorScheme;
    final motor = state.motor;
    final wide = context.windowSizeClass.isAtLeast(WindowSizeClass.expanded);

    return Scaffold(
      backgroundColor: scheme.surface,
      appBar: TsAppBar.back(
        title: 'Detail motor',
        actions: [
          if (motor != null)
            TsIconButton(
              icon: Icons.edit_outlined,
              semanticLabel: 'Ubah motor',
              onPressed: () => _handleEdit(motor),
            ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: state.hasError
            ? ErrorState(
                message: 'Gagal memuat detail motor. Coba lagi.',
                onRetry: viewModel.retry,
                layout: ErrorStateLayout.fullPage,
              )
            : state.isLoading || motor == null
            ? const _DetailSkeleton()
            : SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: wide ? 1064 : 720),
                    child: _DetailContent(
                      state: state,
                      motor: motor,
                      onDelete: () => _handleDelete(state),
                      wide: wide,
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
    required this.motor,
    required this.onDelete,
    this.wide = false,
  });

  final MotorDetailState state;
  final Motor motor;
  final VoidCallback onDelete;
  final bool wide;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final ext = TsThemeExtension.of(context);
    final textTheme = Theme.of(context).textTheme;

    final historyEntries = <MotorHistoryEntry>[
      if (state.activeEntry != null) state.activeEntry!,
      ...state.latestPastHistory,
    ];

    final heroChildren = <Widget>[
      MotorHero(
        motor: motor,
        model: state.model,
        inServiceStatus: state.inServiceStatus,
      ),
      const SizedBox(height: 20),
      _BookingCta(
        inService: state.hasActiveBooking,
        onBook: () => context.push(Routes.bookingVehicles, extra: motor.id),
        onTrack: state.activeEntry == null
            ? null
            : () => context.push(
                Routes.bookingDetail(state.activeEntry!.bookingId),
              ),
      ),
    ];
    final deleteButton = TsButton(
      label: 'Hapus motor',
      type: TsButtonType.dangerGhost,
      leadingIcon: Icons.delete_outline_rounded,
      isLoading: state.isDeleting,
      onPressed: onDelete,
    );
    final infoChildren = <Widget>[
      Text(
        'Detail motor',
        style: textTheme.titleMedium?.copyWith(color: scheme.onSurface),
      ),
      const SizedBox(height: 12),
      MotorDetailsCard(motor: motor, model: state.model),
      const SizedBox(height: 24),
      SectionTitleRow(
        title: 'Riwayat servis',
        onSeeAll: state.showSeeAllHistory
            ? () {
                context.push(Routes.bookings, extra: motor.id);
              }
            : null,
        seeAllSemanticLabel: 'Lihat semua riwayat ${motor.nickname}',
      ),
      const SizedBox(height: 12),
      if (historyEntries.isEmpty)
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: scheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Icon(Icons.history_rounded, color: ext.textMuted, size: 24),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Belum ada riwayat servis',
                      style: textTheme.titleSmall?.copyWith(
                        color: scheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Booking pertama motor ini akan muncul di sini.',
                      style: textTheme.bodyMedium?.copyWith(
                        color: ext.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
      else
        for (final entry in historyEntries) ...[
          ServiceHistoryRow(
            entry: entry,
            onTap: () => context.push(Routes.bookingDetail(entry.bookingId)),
          ),
          const SizedBox(height: 12),
        ],
    ];

    if (wide) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 400,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ...heroChildren,
                const SizedBox(height: 12),
                deleteButton,
              ],
            ),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: infoChildren,
            ),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ...heroChildren,
        const SizedBox(height: 24),
        ...infoChildren,
        const SizedBox(height: 12),
        deleteButton,
      ],
    );
  }
}

class _BookingCta extends StatelessWidget {
  const _BookingCta({
    required this.inService,
    required this.onBook,
    required this.onTrack,
  });

  final bool inService;
  final VoidCallback onBook;
  final VoidCallback? onTrack;

  @override
  Widget build(BuildContext context) {
    final ext = TsThemeExtension.of(context);
    final textTheme = Theme.of(context).textTheme;

    if (!inService) {
      return TsButton(label: 'Booking motor ini', onPressed: onBook);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Semantics(
          container: true,
          excludeSemantics: true,
          button: true,
          enabled: false,
          label: 'Booking motor ini, tidak tersedia. Sedang dalam servis',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const TsButton(label: 'Booking motor ini', onPressed: null),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    size: 16,
                    color: ext.textMuted,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Sedang dalam servis. Kamu bisa booking lagi setelah '
                      'servis selesai.',
                      style: textTheme.bodySmall?.copyWith(
                        color: ext.textMuted,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Align(
          alignment: Alignment.centerLeft,
          child: TsButton(
            label: 'Lacak servis',
            type: TsButtonType.ghost,
            fullWidth: false,
            leadingIcon: Icons.my_location_outlined,
            onPressed: onTrack,
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
    return const Padding(
      padding: EdgeInsets.fromLTRB(20, 16, 20, 32),
      child: Column(
        children: [
          SkeletonBlock(height: 176),
          SizedBox(height: 16),
          SkeletonBlock(height: 48),
          SizedBox(height: 16),
          SkeletonBlock(height: 200),
        ],
      ),
    );
  }
}
