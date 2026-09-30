import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tumbas_servis/app/navigation/routes.dart';
import 'package:tumbas_servis/core/data/service/demo_mode_controller.dart';
import 'package:tumbas_servis/core/data/di/core_data_module.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking_unit.dart';
import 'package:tumbas_servis/core/presentation/components/error_state.dart';
import 'package:tumbas_servis/core/presentation/components/skeleton.dart';
import 'package:tumbas_servis/core/presentation/components/ts_app_bar.dart';
import 'package:tumbas_servis/core/presentation/components/ts_button.dart';
import 'package:tumbas_servis/core/presentation/components/ts_dialog.dart';
import 'package:tumbas_servis/core/presentation/components/ts_segmented_control.dart';
import 'package:tumbas_servis/core/presentation/components/ts_snackbar.dart';
import 'package:tumbas_servis/core/presentation/components/ts_switch.dart';
import 'package:tumbas_servis/core/presentation/theme/ts_theme_extension.dart';
import 'package:tumbas_servis/core/presentation/utils/window_size_class.dart';
import 'package:tumbas_servis/profile/presentation/demo_mode/components/demo_panel.dart';
import 'package:tumbas_servis/profile/presentation/demo_mode/components/demo_preview_pane.dart';
import 'package:tumbas_servis/profile/presentation/demo_mode/components/demo_unit_row.dart';
import 'package:tumbas_servis/profile/presentation/demo_mode/components/error_sim_banner.dart';
import 'package:tumbas_servis/profile/presentation/demo_mode/state/demo_mode_state.dart';
import 'package:tumbas_servis/profile/presentation/di/profile_presentation_module.dart';

class DemoModePage extends ConsumerStatefulWidget {
  const DemoModePage({super.key});

  @override
  ConsumerState<DemoModePage> createState() => _DemoModePageState();
}

class _DemoModePageState extends ConsumerState<DemoModePage> {
  String? _previewUnitCode;

  Future<void> _run(
    BuildContext context,
    Future<bool> Function() action,
    String failure,
  ) async {
    final ok = await action();
    if (!ok && context.mounted) TsSnackbar.error(context, failure);
  }

  Future<void> _confirmReset(BuildContext context) async {
    final confirmed = await TsDialog.confirmDestructive(
      context,
      title: 'Reset semua data?',
      message:
          'Garasi, booking, draft, status notifikasi dibaca, invoice, dan '
          'ulasan dikembalikan ke data awal demo. Sesi, tema, dan pengaturan '
          'demo tetap.',
      confirmLabel: 'Ya, reset data',
      cancelLabel: 'Batal',
    );
    if (confirmed != true || !context.mounted) return;
    final ok = await ref
        .read(demoModeViewModelProvider.notifier)
        .resetAllData();
    if (!context.mounted) return;
    if (!ok) {
      TsSnackbar.error(context, 'Gagal mereset data. Coba lagi.');
      return;
    }
    TsSnackbar.success(context, 'Data demo dikembalikan');
    context.go(Routes.home);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(demoModeViewModelProvider);
    final viewModel = ref.read(demoModeViewModelProvider.notifier);
    final scheme = Theme.of(context).colorScheme;
    final ext = TsThemeExtension.of(context);
    final textTheme = Theme.of(context).textTheme;
    final idle = !state.isBusy && !state.isResetting;
    final isWide = context.windowSizeClass.isAtLeast(WindowSizeClass.expanded);

    BookingUnit? previewUnit;
    for (final unit in state.units) {
      if (unit.unitCode == _previewUnitCode) previewUnit = unit;
    }
    previewUnit ??= state.units.isEmpty ? null : state.units.first;

    final caption = Text(
      'Kontrol status khusus demo — bukan bagian produk.',
      style: textTheme.bodyMedium?.copyWith(color: ext.textMuted),
    );
    final speedPanel = DemoPanel(
      title: 'Kecepatan',
      child: TsSegmentedControl<TrackingSpeed>(
        semanticLabel: 'Kecepatan status otomatis',
        selected: state.speed,
        onChanged: viewModel.setSpeed,
        segments: const [
          TsSegment(value: TrackingSpeed.mati, label: 'Mati'),
          TsSegment(value: TrackingSpeed.detik15, label: '15 dtk'),
          TsSegment(value: TrackingSpeed.detik5, label: '5 dtk'),
        ],
      ),
    );
    final statusPanel = DemoPanel(
      title: state.hasActiveBooking
          ? 'Status booking ${state.bookingCode}'
          : 'Status booking',
      child: _BookingControls(
        state: state,
        idle: idle,
        selectedUnitCode: isWide ? previewUnit?.unitCode : null,
        onSelect: isWide
            ? (code) => setState(() => _previewUnitCode = code)
            : null,
        onAdvance: (code) => _run(
          context,
          () => viewModel.advanceUnit(code),
          'Gagal memajukan status. Coba lagi.',
        ),
        onReset: (code) => _run(
          context,
          () => viewModel.resetUnit(code),
          'Gagal mereset status. Coba lagi.',
        ),
        onAdvanceAll: () => _run(
          context,
          viewModel.advanceAll,
          'Gagal memajukan status. Coba lagi.',
        ),
        onResetAll: () => _run(
          context,
          viewModel.resetAll,
          'Gagal mereset status. Coba lagi.',
        ),
      ),
    );
    final errorPanel = DemoPanel(
      title: 'Simulasi galat',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Simulasikan galat jaringan',
                  style: textTheme.bodyLarge?.copyWith(color: scheme.onSurface),
                ),
              ),
              TsSwitch(
                value: state.errorArmed,
                semanticLabel: 'Simulasikan galat jaringan',
                onChanged: viewModel.setErrorArmed,
              ),
            ],
          ),
          if (state.errorArmed) ...[
            const SizedBox(height: 8),
            const ErrorSimBanner(),
          ],
        ],
      ),
    );
    final dataPanel = DemoPanel(
      title: 'Data demo',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Kembalikan garasi, booking, draft, notifikasi, invoice, dan '
            'ulasan ke data awal.',
            style: textTheme.bodyMedium?.copyWith(color: ext.textBody),
          ),
          const SizedBox(height: 12),
          TsButton(
            label: 'Reset semua data',
            type: TsButtonType.dangerOutline,
            isLoading: state.isResetting,
            loadingLabel: 'Mengembalikan data…',
            onPressed: idle ? () => _confirmReset(context) : null,
          ),
        ],
      ),
    );

    Widget content() {
      if (!isWide) {
        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 560),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    caption,
                    const SizedBox(height: 16),
                    speedPanel,
                    const SizedBox(height: 16),
                    statusPanel,
                    const SizedBox(height: 16),
                    errorPanel,
                    const SizedBox(height: 16),
                    dataPanel,
                  ],
                ),
              ),
            ),
          ],
        );
      }

      return SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1192),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 632,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      caption,
                      const SizedBox(height: 16),
                      speedPanel,
                      const SizedBox(height: 16),
                      statusPanel,
                    ],
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  flex: 560,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      DemoPreviewPane(
                        unit: previewUnit,
                        now: ref.read(clockProvider).now(),
                      ),
                      const SizedBox(height: 16),
                      errorPanel,
                      const SizedBox(height: 16),
                      dataPanel,
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: scheme.surface,
      appBar: TsAppBar.back(
        title: 'Mode Demo',
        onBack: () =>
            context.canPop() ? context.pop() : context.go(Routes.profile),
      ),
      body: SafeArea(
        top: false,
        child: state.hasError
            ? ErrorState(
                message: 'Gagal memuat panel demo. Coba lagi.',
                onRetry: viewModel.retry,
                layout: ErrorStateLayout.fullPage,
              )
            : state.isLoading
            ? const _DemoSkeleton()
            : content(),
      ),
    );
  }
}

class _BookingControls extends StatelessWidget {
  const _BookingControls({
    required this.state,
    required this.idle,
    required this.onAdvance,
    required this.onReset,
    required this.onAdvanceAll,
    required this.onResetAll,
    this.selectedUnitCode,
    this.onSelect,
  });

  final String? selectedUnitCode;
  final ValueChanged<String>? onSelect;
  final DemoModeState state;
  final bool idle;
  final ValueChanged<String> onAdvance;
  final ValueChanged<String> onReset;
  final VoidCallback onAdvanceAll;
  final VoidCallback onResetAll;

  @override
  Widget build(BuildContext context) {
    final ext = TsThemeExtension.of(context);
    final textTheme = Theme.of(context).textTheme;

    if (!state.hasActiveBooking) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            DemoModeState.noActiveBookingReason,
            style: textTheme.bodyMedium?.copyWith(color: ext.textMuted),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: const [
              TsButton(
                label: 'Majukan semua',
                type: TsButtonType.outline,
                compact: true,
                fullWidth: false,
                onPressed: null,
              ),
              TsButton(
                label: 'Reset semua',
                type: TsButtonType.ghost,
                compact: true,
                fullWidth: false,
                onPressed: null,
              ),
            ],
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final unit in state.units) ...[
          DemoUnitRow(
            unit: unit,
            enabled: idle,
            selected: unit.unitCode == selectedUnitCode,
            onSelect: onSelect == null ? null : () => onSelect!(unit.unitCode),
            onAdvance: () => onAdvance(unit.unitCode),
            onReset: () => onReset(unit.unitCode),
          ),
          const SizedBox(height: 8),
        ],
        const SizedBox(height: 4),
        Wrap(
          spacing: 12,
          runSpacing: 8,
          children: [
            TsButton(
              label: 'Majukan semua',
              type: TsButtonType.outline,
              compact: true,
              fullWidth: false,
              onPressed: idle && state.canAdvanceAny ? onAdvanceAll : null,
            ),
            TsButton(
              label: 'Reset semua',
              type: TsButtonType.ghost,
              compact: true,
              fullWidth: false,
              onPressed: idle && state.canResetAny ? onResetAll : null,
            ),
          ],
        ),
      ],
    );
  }
}

class _DemoSkeleton extends StatelessWidget {
  const _DemoSkeleton();

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Memuat panel demo',
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        children: const [
          SkeletonBlock(
            height: 96,
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          SizedBox(height: 16),
          SkeletonBlock(
            height: 240,
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          SizedBox(height: 16),
          SkeletonBlock(
            height: 96,
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
        ],
      ),
    );
  }
}
