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
import 'package:tumbas_servis/core/presentation/components/selection_footer.dart';
import 'package:tumbas_servis/core/presentation/components/skeleton.dart';
import 'package:tumbas_servis/core/presentation/components/ts_app_bar.dart';
import 'package:tumbas_servis/core/presentation/components/ts_snackbar.dart';
import 'package:tumbas_servis/core/presentation/theme/ts_theme_extension.dart';

class PilihMotorPage extends ConsumerStatefulWidget {
  const PilihMotorPage({super.key});

  @override
  ConsumerState<PilihMotorPage> createState() => _PilihMotorPageState();
}

class _PilihMotorPageState extends ConsumerState<PilihMotorPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      await ref.read(bookingDraftProvider.notifier).refreshActiveBookings();
      _noticePrunedMotors();
    });
  }

  void _noticePrunedMotors() {
    if (!mounted) return;
    final pruned = ref.read(bookingDraftProvider.notifier).takePrunedCount();
    if (pruned == 0) return;
    TsSnackbar.info(
      context,
      '$pruned motor dilepas dari draft karena sedang dalam servis',
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(bookingDraftProvider, (_, _) => _noticePrunedMotors());

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
        TsSnackbar.success(context, 'Motor ditambahkan');
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
                      SelectionFooter(
                        recapLine:
                            '$selectedCount dari $bookingDraftMaxMotors motor '
                            'dipilih',
                        reasonLine: selectionReasonLine(
                          isLoading: state.isLoading,
                          selectedCount: selectedCount,
                        ),
                        ctaLabel: 'Lanjut',
                        canContinue: canContinue,
                        isLoading: state.isLoading,
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
