import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tumbas_servis/app/navigation/routes.dart';
import 'package:tumbas_servis/core/data/di/core_data_module.dart';
import 'package:tumbas_servis/core/domain/model/booking/unit_status.dart';
import 'package:tumbas_servis/core/presentation/components/error_state.dart';
import 'package:tumbas_servis/core/presentation/components/skeleton.dart';
import 'package:tumbas_servis/core/presentation/components/ts_app_bar.dart';
import 'package:tumbas_servis/core/presentation/components/ts_button.dart';
import 'package:tumbas_servis/core/presentation/components/ts_snackbar.dart';
import 'package:tumbas_servis/core/presentation/components/unit_status_badge.dart';
import 'package:tumbas_servis/core/presentation/theme/ts_theme_extension.dart';
import 'package:tumbas_servis/tracking/presentation/di/tracking_presentation_module.dart';
import 'package:tumbas_servis/tracking/presentation/lacak_unit/components/demo_mode_shortcut.dart';
import 'package:tumbas_servis/tracking/presentation/lacak_unit/components/mechanic_card.dart';
import 'package:tumbas_servis/tracking/presentation/lacak_unit/components/status_timeline.dart';
import 'package:tumbas_servis/tracking/presentation/lacak_unit/lacak_unit_view_model.dart';
import 'package:tumbas_servis/tracking/presentation/lacak_unit/state/lacak_unit_state.dart';
import 'package:tumbas_servis/tracking/presentation/utils/tracking_display.dart';

class LacakUnitPage extends ConsumerWidget {
  const LacakUnitPage({
    required this.bookingId,
    required this.unitCode,
    super.key,
  });

  final String bookingId;
  final String unitCode;

  LacakUnitArgs get _args => (bookingId: bookingId, unitCode: unitCode);

  void _goBack(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(Routes.bookingDetail(bookingId));
    }
  }

  Future<void> _demo(
    BuildContext context,
    WidgetRef ref,
    Future<bool> Function(LacakUnitViewModel vm) action,
  ) async {
    final ok = await action(
      ref.read(lacakUnitViewModelProvider(_args).notifier),
    );
    if (!ok && context.mounted) {
      TsSnackbar.error(context, 'Gagal mengubah status. Coba lagi.');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = lacakUnitViewModelProvider(_args);
    final state = ref.watch(provider);
    final viewModel = ref.read(provider.notifier);
    final scheme = Theme.of(context).colorScheme;
    final unit = state.unit;

    return Scaffold(
      backgroundColor: scheme.surface,
      appBar: TsAppBar.back(
        title: 'Lacak unit',
        onBack: () => _goBack(context),
      ),
      body: SafeArea(
        top: false,
        child: state.hasError
            ? ErrorState(
                message: 'Gagal memuat status unit. Coba lagi.',
                onRetry: viewModel.retry,
                layout: ErrorStateLayout.fullPage,
              )
            : state.isLoading || unit == null
            ? const _LacakSkeleton()
            : SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 640),
                    child: _LacakContent(
                      state: state,
                      now: ref.read(clockProvider).now(),
                      onAdvance: state.canAdvance
                          ? () => _demo(context, ref, (vm) => vm.advance())
                          : null,
                      onReset: state.canReset
                          ? () => _demo(context, ref, (vm) => vm.reset())
                          : null,
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}

class _LacakContent extends StatelessWidget {
  const _LacakContent({
    required this.state,
    required this.now,
    required this.onAdvance,
    required this.onReset,
  });

  final LacakUnitState state;
  final DateTime now;
  final VoidCallback? onAdvance;
  final VoidCallback? onReset;

  @override
  Widget build(BuildContext context) {
    final unit = state.unit!;
    final scheme = Theme.of(context).colorScheme;
    final ext = TsThemeExtension.of(context);
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
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
                      unit.motorSnapshot.nickname,
                      style: textTheme.titleLarge?.copyWith(
                        color: scheme.onSurface,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  UnitStatusBadge(status: unit.status),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                '${unit.motorSnapshot.plateNumber} · Unit ${unit.unitCode}',
                style: textTheme.bodyMedium?.copyWith(color: ext.textMuted),
              ),
              if (state.servicesSummary.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(
                  state.servicesSummary,
                  style: textTheme.bodyLarge?.copyWith(color: ext.textBody),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 16),
        _StatusCard(state: state),
        const SizedBox(height: 16),
        StatusTimeline(unit: unit, now: now),
        if (!state.isCancelled) ...[
          const SizedBox(height: 24),
          MechanicCard(unitCode: unit.unitCode, mechanic: state.mechanic),
        ],
        if (state.showDemoShortcut) ...[
          const SizedBox(height: 16),
          DemoModeShortcut(onAdvance: onAdvance, onReset: onReset),
        ],
        if (state.isCancelled) ...[
          const SizedBox(height: 16),
          TsButton(
            label: 'Booking lagi',
            type: TsButtonType.outline,
            onPressed: () =>
                context.push(Routes.bookingVehicles, extra: [unit.motorId]),
          ),
        ],
      ],
    );
  }
}

class _StatusCard extends StatelessWidget {
  const _StatusCard({required this.state});

  final LacakUnitState state;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final ext = TsThemeExtension.of(context);
    final textTheme = Theme.of(context).textTheme;
    final unit = state.unit!;

    final String title;
    final String body;
    final Color background;
    final Color foreground;
    final IconData icon;

    if (state.isCancelled) {
      final event = cancelEvent(unit);
      title = 'Booking dibatalkan';
      body = event == null ? '' : fullStamp(event.timestamp);
      background = ext.dangerSoft;
      foreground = ext.dangerText;
      icon = Icons.cancel_outlined;
    } else if (state.isCompleted) {
      final done = state.completedAt;
      title = 'Selesai';
      body = done == null ? '' : fullStamp(done);
      background = ext.successSoft;
      foreground = ext.successText;
      icon = Icons.check_circle_outline_rounded;
    } else {
      final eta = state.estimatedFinish;
      title = 'Estimasi selesai';
      body = eta == null
          ? 'Akan diperbarui montir'
          : '±${timeOnly(eta)} · '
                '${unit.status == UnitStatus.terjadwal ? 'dihitung dari jam datang' : 'akan diperbarui montir'}';
      background = scheme.primaryContainer;
      foreground = scheme.onPrimaryContainer;
      icon = Icons.schedule_rounded;
    }

    return Semantics(
      container: true,
      liveRegion: true,
      label: '$title. $body',
      excludeSemantics: true,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(icon, color: foreground, size: 28),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: textTheme.titleMedium?.copyWith(color: foreground),
                  ),
                  if (body.isNotEmpty)
                    Text(
                      body,
                      style: textTheme.bodyMedium?.copyWith(color: foreground),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LacakSkeleton extends StatelessWidget {
  const _LacakSkeleton();

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Memuat status unit',
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        child: Column(
          children: [
            const SkeletonBlock(height: 128),
            const SizedBox(height: 16),
            const SkeletonBlock(height: 76),
            const SizedBox(height: 24),
            for (var i = 0; i < 4; i++) ...[
              const Row(
                children: [
                  SkeletonAvatar(size: 36),
                  SizedBox(width: 16),
                  Expanded(child: SkeletonLine(height: 16)),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ],
        ),
      ),
    );
  }
}
