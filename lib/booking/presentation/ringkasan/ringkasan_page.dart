import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tumbas_servis/app/navigation/routes.dart';
import 'package:tumbas_servis/booking/presentation/components/booking_stepper.dart';
import 'package:tumbas_servis/booking/presentation/di/booking_presentation_module.dart';
import 'package:tumbas_servis/booking/presentation/ringkasan/components/confirm_pane.dart';
import 'package:tumbas_servis/booking/presentation/ringkasan/components/estimate_breakdown.dart';
import 'package:tumbas_servis/booking/presentation/ringkasan/components/payment_note.dart';
import 'package:tumbas_servis/booking/presentation/ringkasan/components/price_line.dart';
import 'package:tumbas_servis/booking/presentation/ringkasan/components/summary_card.dart';
import 'package:tumbas_servis/booking/presentation/ringkasan/components/unit_summary_accordion.dart';
import 'package:tumbas_servis/booking/presentation/ringkasan/components/voucher_row.dart';
import 'package:tumbas_servis/booking/presentation/ringkasan/ringkasan_view_model.dart';
import 'package:tumbas_servis/booking/presentation/ringkasan/state/ringkasan_state.dart';
import 'package:tumbas_servis/booking/presentation/utils/ringkasan_display.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking_draft.dart';
import 'package:tumbas_servis/core/domain/model/catalog/part.dart';
import 'package:tumbas_servis/core/domain/model/catalog/service_type.dart';
import 'package:tumbas_servis/core/domain/service/pricing_duration/pricing_calculator.dart';
import 'package:tumbas_servis/core/presentation/components/confirm_bar.dart';
import 'package:tumbas_servis/core/presentation/components/empty_state.dart';
import 'package:tumbas_servis/core/presentation/components/error_state.dart';
import 'package:tumbas_servis/core/presentation/components/max_width_box.dart';
import 'package:tumbas_servis/core/presentation/components/skeleton.dart';
import 'package:tumbas_servis/core/presentation/components/ts_app_bar.dart';
import 'package:tumbas_servis/core/presentation/components/ts_snackbar.dart';
import 'package:tumbas_servis/core/presentation/theme/ts_theme_extension.dart';
import 'package:tumbas_servis/core/presentation/utils/currency_formatter.dart';
import 'package:tumbas_servis/core/presentation/utils/window_size_class.dart';

const _pricingCalculator = PricingCalculator();

class RingkasanPage extends ConsumerStatefulWidget {
  const RingkasanPage({super.key});

  @override
  ConsumerState<RingkasanPage> createState() => _RingkasanPageState();
}

class _RingkasanPageState extends ConsumerState<RingkasanPage> {
  @override
  void initState() {
    super.initState();
    Future(() => ref.read(ringkasanViewModelProvider.notifier).reload());
  }

  Future<void> _navigateAndReload(String path) async {
    final isEdit = path != Routes.bookingSummaryVoucher;
    final editReturn = ref.read(summaryEditReturnProvider.notifier);
    if (isEdit) editReturn.begin();
    await context.push(path);
    if (isEdit) editReturn.end();
    if (!mounted) return;
    ref.read(ringkasanViewModelProvider.notifier).reload();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(ringkasanViewModelProvider, (previous, next) {
      final bookingId = next.confirmedBookingId;
      if (bookingId != null && previous?.confirmedBookingId != bookingId) {
        ref.read(summaryEditReturnProvider.notifier).end();
        ref.read(bookingDraftProvider.notifier).reset();
        context.go(Routes.bookingSuccess(bookingId));
      }
      final notice = next.voucherNotice;
      if (notice != null && notice != previous?.voucherNotice) {
        TsSnackbar.info(context, notice);
        ref.read(ringkasanViewModelProvider.notifier).clearVoucherNotice();
      }
    });

    final draft = ref.watch(bookingDraftProvider);
    final state = ref.watch(ringkasanViewModelProvider);
    final viewModel = ref.read(ringkasanViewModelProvider.notifier);
    final scheme = Theme.of(context).colorScheme;

    Widget body;
    if (state.hasError) {
      body = ErrorState(
        message: 'Ringkasan gagal dimuat. Coba lagi.',
        onRetry: viewModel.reload,
        layout: ErrorStateLayout.fullPage,
      );
    } else if (state.isLoading || draft == null) {
      body = const _LoadingBody();
    } else if (draft.selectedMotorIds.isEmpty) {
      body = EmptyState(
        title: 'Belum ada motor dipilih',
        body: 'Kembali ke langkah sebelumnya untuk memilih motor.',
        ctaLabel: 'Pilih motor',
        onCta: () => Navigator.of(context).pop(),
      );
    } else {
      body = _RingkasanBody(
        draft: draft,
        state: state,
        viewModel: viewModel,
        onNavigate: _navigateAndReload,
      );
    }

    return Scaffold(
      backgroundColor: scheme.surface,
      appBar: TsAppBar.back(title: 'Ringkasan'),
      body: SafeArea(top: false, child: body),
    );
  }
}

class _LoadingBody extends StatelessWidget {
  const _LoadingBody();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const BookingStepper(currentStep: 4),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
            children: const [
              SkeletonBlock(height: 96),
              SizedBox(height: 12),
              SkeletonBlock(height: 72),
              SizedBox(height: 8),
              SkeletonBlock(height: 72),
              SizedBox(height: 12),
              SkeletonBlock(height: 64),
              SizedBox(height: 12),
              SkeletonBlock(height: 160),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.fromLTRB(20, 12, 20, 12),
          child: SkeletonBlock(height: 72),
        ),
      ],
    );
  }
}

class _RingkasanBody extends StatelessWidget {
  const _RingkasanBody({
    required this.draft,
    required this.state,
    required this.viewModel,
    required this.onNavigate,
  });

  final BookingDraft draft;
  final RingkasanState state;
  final RingkasanViewModel viewModel;
  final Future<void> Function(String path) onNavigate;

  @override
  Widget build(BuildContext context) {
    final ext = TsThemeExtension.of(context);
    final textTheme = Theme.of(context).textTheme;

    final units = buildUnitLines(
      draft: draft,
      motorsById: state.motorsById,
      serviceById: state.serviceById,
      partById: state.partById,
    );
    final unitSubtotals = units.map((u) => u.subtotal).toList();
    final breakdown = _pricingCalculator.breakdown(
      unitSubtotals: unitSubtotals,
      voucher: state.voucher,
    );
    final durationCaption = estimateDurationCaption(
      draft: draft,
      units: units,
      bayCount: state.workshop?.bayCount ?? 1,
    );
    final canConfirm = !state.slotInvalid && !state.confirming;
    final reasonLine = state.slotInvalid
        ? 'Pilih jadwal baru untuk lanjut'
        : null;

    final sizeClass = context.windowSizeClass;
    final isTwoPane = sizeClass.isAtLeast(WindowSizeClass.expanded);

    final voucherRow = VoucherRow(
      variant: state.voucher != null
          ? VoucherRowVariant.applied
          : VoucherRowVariant.empty,
      titleText: state.voucher?.label,
      captionText: state.voucher == null ? 'Pilih voucher' : null,
      savingText: state.voucher == null
          ? null
          : 'Hemat ${CurrencyFormatter.format(_pricingCalculator.voucherDiscount(subtotal: breakdown.subtotal, voucher: state.voucher!))}',
      onTap: () => onNavigate(Routes.bookingSummaryVoucher),
      onHapus: () async {
        final removed = state.voucher;
        await viewModel.removeVoucher();
        if (!context.mounted || removed == null) return;
        TsSnackbar.info(
          context,
          'Voucher dilepas',
          actionLabel: 'Urungkan',
          onAction: viewModel.undoRemoveVoucher,
        );
      },
    );

    EstimateBreakdown estimate({required bool bordered}) => EstimateBreakdown(
      unitLines: [
        for (final unit in units)
          (label: unit.motor.nickname, subtotal: unit.subtotal),
      ],
      subtotal: breakdown.subtotal,
      discount: breakdown.discount,
      total: breakdown.total,
      voucherLabel: state.voucher?.label,
      durationCaption: durationCaption,
      bordered: bordered,
    );

    final recap = <Widget>[
      if (state.confirmError != null)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: ErrorState(
            message: state.confirmError!,
            onRetry: viewModel.confirm,
          ),
        ),
      SummaryCard(
        workshopName: state.workshop?.name ?? '',
        jadwalLine: jadwalSummaryLine(draft, state.motorsById),
        jadwalInvalid: state.slotInvalid,
        onUbahBengkel: () => onNavigate(Routes.bookingWorkshop),
        onUbahJadwal: () => onNavigate(Routes.bookingSchedule),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
        child: Text(
          'Motor (${units.length})',
          style: textTheme.titleSmall?.copyWith(color: ext.textBody),
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            for (final unit in units)
              UnitSummaryAccordion(
                motor: unit.motor,
                summaryLine: unitServiceSummary(unit),
                expanded: state.expandedMotorIds.contains(unit.motorId),
                onToggle: () => viewModel.toggleAccordion(unit.motorId),
                onUbah: () => onNavigate(Routes.bookingConfigure),
                body: _UnitDetailLines(unit: unit),
              ),
          ],
        ),
      ),
    ];

    if (isTwoPane) {
      return Column(
        children: [
          const BookingStepper(currentStep: 4),
          Expanded(
            child: MaxWidthBox(
              maxWidth: 720 + 24 + 360 + 48,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: recap,
                        ),
                      ),
                    ),
                    const SizedBox(width: 24),
                    SizedBox(
                      width: 360,
                      child: ConfirmPane(
                        voucherRow: voucherRow,
                        estimate: estimate(bordered: false),
                        ctaLabel: 'Konfirmasi booking',
                        loadingLabel: 'Mengonfirmasi…',
                        enabled: canConfirm,
                        isLoading: state.confirming,
                        reasonLine: reasonLine,
                        onConfirm: viewModel.confirm,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    }

    final isMedium = sizeClass == WindowSizeClass.medium;
    final stacked = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...recap,
        voucherRow,
        estimate(bordered: true),
        const PaymentNote(),
      ],
    );

    return Column(
      children: [
        const BookingStepper(currentStep: 4),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 12),
            child: isMedium
                ? MaxWidthBox(maxWidth: 720, child: stacked)
                : stacked,
          ),
        ),
        ConfirmBar(
          totalLabel: 'Total estimasi',
          ctaLabel: 'Konfirmasi booking',
          loadingLabel: 'Mengonfirmasi…',
          totalValue: CurrencyFormatter.format(breakdown.total),
          enabled: canConfirm,
          isLoading: state.confirming,
          reasonLine: reasonLine,
          maxContentWidth: isMedium ? 720 : null,
          onConfirm: viewModel.confirm,
        ),
      ],
    );
  }
}

class _UnitDetailLines extends StatelessWidget {
  const _UnitDetailLines({required this.unit});

  final RingkasanUnitLine unit;

  @override
  Widget build(BuildContext context) {
    final ext = TsThemeExtension.of(context);
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final ServiceType service in unit.services)
          PriceLine(
            label: service.name,
            value: CurrencyFormatter.format(service.price),
          ),
        for (final Part part in unit.parts)
          PriceLine(
            label: part.name,
            value: CurrencyFormatter.format(part.price),
          ),
        if (unit.complaintNote != null && unit.complaintNote!.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            'Keluhan',
            style: textTheme.labelSmall?.copyWith(color: ext.textMuted),
          ),
          Text(
            unit.complaintNote!,
            style: textTheme.bodySmall?.copyWith(color: ext.textBody),
          ),
        ],
      ],
    );
  }
}
