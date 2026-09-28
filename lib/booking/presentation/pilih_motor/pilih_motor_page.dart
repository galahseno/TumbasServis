import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tumbas_servis/app/navigation/routes.dart';
import 'package:tumbas_servis/booking/presentation/booking_draft/booking_draft_view_model.dart';
import 'package:tumbas_servis/booking/presentation/components/booking_stepper.dart';
import 'package:tumbas_servis/booking/presentation/components/exit_booking_dialog.dart';
import 'package:tumbas_servis/booking/presentation/di/booking_presentation_module.dart';
import 'package:tumbas_servis/booking/presentation/pilih_motor/components/add_motor_card.dart';
import 'package:tumbas_servis/booking/presentation/pilih_motor/components/motor_select_card.dart';
import 'package:tumbas_servis/booking/presentation/utils/motor_select_display.dart';
import 'package:tumbas_servis/booking/presentation/utils/selection_footer_display.dart';
import 'package:tumbas_servis/core/domain/model/garage/motor.dart';
import 'package:tumbas_servis/core/presentation/components/empty_state.dart';
import 'package:tumbas_servis/core/presentation/components/error_state.dart';
import 'package:tumbas_servis/core/presentation/components/skeleton.dart';
import 'package:tumbas_servis/core/presentation/components/ts_app_bar.dart';
import 'package:tumbas_servis/core/presentation/components/ts_button.dart';
import 'package:tumbas_servis/core/presentation/theme/ts_theme_extension.dart';

class PilihMotorPage extends ConsumerWidget {
  const PilihMotorPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final draft = ref.watch(bookingDraftProvider);
    final draftNotifier = ref.read(bookingDraftProvider.notifier);
    final state = ref.watch(pilihMotorViewModelProvider);
    final viewModel = ref.read(pilihMotorViewModelProvider.notifier);
    final scheme = Theme.of(context).colorScheme;

    final selectedIds = draft?.selectedMotorIds ?? const <String>[];
    final selectedCount = selectedIds.length;
    final isMaxReached = selectedCount >= bookingDraftMaxMotors;
    final canContinue = selectedCount > 0;

    Future<void> handleExit() async {
      if (selectedCount == 0) {
        Navigator.of(context).pop();
        return;
      }
      final confirmed = await showExitBookingDialog(context);
      if ((confirmed ?? false) && context.mounted) {
        Navigator.of(context).pop();
      }
    }

    Future<void> handleAddMotor() async {
      final countBefore = state.motors.length;
      await context.push(Routes.garageAdd);
      if (!context.mounted) return;
      await viewModel.refresh();
      final refreshed = ref.read(pilihMotorViewModelProvider);
      if (refreshed.motors.length > countBefore && context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Motor ditambahkan')));
      }
    }

    return PopScope(
      canPop: selectedCount == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        handleExit();
      },
      child: Scaffold(
        backgroundColor: scheme.surface,
        appBar: TsAppBar.close(
          title: 'Pilih motor',
          onClose: handleExit,
          semanticLabel: 'Tutup booking',
        ),
        body: state.hasError
            ? ErrorState(
                message: 'Gagal memuat daftar motor. Coba lagi.',
                onRetry: viewModel.refresh,
                layout: ErrorStateLayout.fullPage,
              )
            : SafeArea(
                top: false,
                child: Column(
                  children: [
                    BookingStepper(currentStep: 1),
                    Expanded(
                      child: state.isGarageEmpty
                          ? EmptyState(
                              title: 'Belum ada motor di garasi',
                              body: 'Tambahkan motor untuk mulai booking.',
                              ctaLabel: 'Tambah motor pertamamu',
                              onCta: handleAddMotor,
                            )
                          : _MotorGrid(
                              isLoading: state.isLoading,
                              motors: state.motors,
                              selectedIds: selectedIds,
                              isMaxReached: isMaxReached,
                              draftNotifier: draftNotifier,
                              onAddMotor: handleAddMotor,
                            ),
                    ),
                    if (!state.isGarageEmpty)
                      _SelectionFooter(
                        selectedCount: selectedCount,
                        isLoading: state.isLoading,
                        canContinue: canContinue,
                        onContinue: () => context.push(Routes.bookingConfigure),
                      ),
                  ],
                ),
              ),
      ),
    );
  }
}

class _MotorGrid extends StatelessWidget {
  const _MotorGrid({
    required this.isLoading,
    required this.motors,
    required this.selectedIds,
    required this.isMaxReached,
    required this.draftNotifier,
    required this.onAddMotor,
  });

  final bool isLoading;
  final List<Motor> motors;
  final List<String> selectedIds;
  final bool isMaxReached;
  final BookingDraftViewModel draftNotifier;
  final VoidCallback onAddMotor;

  int _columnsFor(double width) {
    if (width >= 1024) return 3;
    if (width >= 600) return 2;
    return 1;
  }

  @override
  Widget build(BuildContext context) {
    final ext = TsThemeExtension.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = _columnsFor(constraints.maxWidth);
        const spacing = 12.0;
        final contentWidth = constraints.maxWidth > 1040
            ? 1040.0
            : constraints.maxWidth;
        final cardWidth = (contentWidth - (columns - 1) * spacing) / columns;

        return Center(
          child: SizedBox(
            width: contentWidth,
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Yuk, pilih motor yang mau diservis',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Bisa sampai 5 motor sekaligus. Servis tiap motor diatur '
                    'di langkah berikutnya.',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: ext.textMuted),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: spacing,
                    runSpacing: spacing,
                    children: [
                      if (isLoading)
                        for (var i = 0; i < 3; i++)
                          SizedBox(
                            width: cardWidth,
                            child: const SkeletonBlock(height: 88),
                          )
                      else ...[
                        for (final motor in motors)
                          SizedBox(
                            width: cardWidth,
                            child: Builder(
                              builder: (context) {
                                final selected = selectedIds.contains(motor.id);
                                final hasActiveBooking = draftNotifier
                                    .hasActiveBooking(motor.id);
                                final reason = motor.disabledReason(
                                  hasActiveBooking: hasActiveBooking,
                                  isMaxReached: isMaxReached,
                                );
                                return MotorSelectCard(
                                  nickname: motor.nickname,
                                  plateNumber: motor.plateNumber,
                                  selected: selected,
                                  disabledReason: selected ? null : reason,
                                  semanticLabel: motor.semanticLabel(
                                    selected: selected,
                                    hasActiveBooking: hasActiveBooking,
                                    isMaxReached: isMaxReached,
                                  ),
                                  onTap: () {
                                    if (selected) {
                                      draftNotifier.deselectMotor(motor.id);
                                    } else if (draftNotifier.isMotorSelectable(
                                      motor,
                                    )) {
                                      draftNotifier.selectMotor(motor.id);
                                    }
                                  },
                                );
                              },
                            ),
                          ),
                        SizedBox(
                          width: cardWidth,
                          child: AddMotorCard(onTap: onAddMotor),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _SelectionFooter extends StatelessWidget {
  const _SelectionFooter({
    required this.selectedCount,
    required this.isLoading,
    required this.canContinue,
    required this.onContinue,
  });

  final int selectedCount;
  final bool isLoading;
  final bool canContinue;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final ext = TsThemeExtension.of(context);
    final textTheme = Theme.of(context).textTheme;
    final reasonLine = selectionReasonLine(
      isLoading: isLoading,
      selectedCount: selectedCount,
    );

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
      decoration: BoxDecoration(
        color: scheme.surface,
        border: Border(top: BorderSide(color: ext.borderDefault)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Semantics(
              liveRegion: true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '$selectedCount dari $bookingDraftMaxMotors motor dipilih',
                    style: textTheme.labelLarge?.copyWith(color: ext.textBody),
                  ),
                  if (reasonLine != null)
                    Text(
                      reasonLine,
                      style: textTheme.bodySmall?.copyWith(
                        color: ext.textMuted,
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 120,
            child: TsButton(
              label: 'Lanjut',
              fullWidth: false,
              onPressed: (canContinue && !isLoading) ? onContinue : null,
            ),
          ),
        ],
      ),
    );
  }
}
