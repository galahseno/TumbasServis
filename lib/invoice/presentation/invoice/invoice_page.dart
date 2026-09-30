import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tumbas_servis/app/navigation/routes.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking_unit.dart';
import 'package:tumbas_servis/core/domain/model/invoice/invoice.dart';
import 'package:tumbas_servis/core/domain/model/invoice/invoice_line.dart';
import 'package:tumbas_servis/core/presentation/components/confirm_bar.dart';
import 'package:tumbas_servis/core/presentation/components/error_state.dart';
import 'package:tumbas_servis/core/presentation/components/skeleton.dart';
import 'package:tumbas_servis/core/presentation/components/ts_app_bar.dart';
import 'package:tumbas_servis/core/presentation/components/ts_button.dart';
import 'package:tumbas_servis/core/presentation/components/ts_dialog.dart';
import 'package:tumbas_servis/core/presentation/theme/ts_theme_extension.dart';
import 'package:tumbas_servis/core/presentation/utils/currency_formatter.dart';
import 'package:tumbas_servis/core/presentation/utils/date_formatter.dart';
import 'package:tumbas_servis/core/presentation/utils/time_formatter.dart';
import 'package:tumbas_servis/core/presentation/utils/window_size_class.dart';
import 'package:tumbas_servis/invoice/presentation/di/invoice_presentation_module.dart';
import 'package:tumbas_servis/invoice/presentation/invoice/components/invoice_header_card.dart';
import 'package:tumbas_servis/invoice/presentation/invoice/components/invoice_summary_card.dart';
import 'package:tumbas_servis/invoice/presentation/invoice/components/invoice_totals.dart';
import 'package:tumbas_servis/invoice/presentation/invoice/components/paid_banner.dart';
import 'package:tumbas_servis/invoice/presentation/invoice/components/price_breakdown_invoice.dart';
import 'package:tumbas_servis/invoice/presentation/invoice/invoice_view_model.dart';
import 'package:tumbas_servis/invoice/presentation/invoice/state/invoice_state.dart';

class InvoicePage extends ConsumerWidget {
  const InvoicePage({required this.bookingId, super.key});

  final String bookingId;

  void _goBack(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(Routes.bookingDetail(bookingId));
    }
  }

  Future<void> _confirmMarkPaid(BuildContext context, WidgetRef ref) async {
    final confirmed = await TsDialog.confirmSave(
      context,
      title: 'Tandai sudah dibayar?',
      message: 'Simulasi, tidak ada pembayaran sungguhan.',
      confirmLabel: 'Ya, tandai lunas',
      cancelLabel: 'Batal',
    );
    if (confirmed != true || !context.mounted) return;
    await ref.read(invoiceViewModelProvider(bookingId).notifier).markPaid();
  }

  void _openReview(BuildContext context) =>
      context.pushReplacement(Routes.review(bookingId));

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = invoiceViewModelProvider(bookingId);
    final state = ref.watch(provider);
    final viewModel = ref.read(provider.notifier);
    final scheme = Theme.of(context).colorScheme;
    final isWide = context.windowSizeClass.isAtLeast(WindowSizeClass.expanded);

    return Scaffold(
      backgroundColor: scheme.surface,
      appBar: TsAppBar.back(title: 'Invoice', onBack: () => _goBack(context)),
      body: SafeArea(
        top: false,
        child: state.hasError
            ? ErrorState(
                message: 'Gagal memuat invoice. Coba lagi.',
                onRetry: viewModel.retry,
                layout: ErrorStateLayout.fullPage,
              )
            : !state.isReady
            ? const _InvoiceSkeleton()
            : isWide
            ? _buildWide(context, ref, state, viewModel)
            : Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: context.isTablet ? 640 : 720,
                          ),
                          child: _InvoiceContent(
                            state: state,
                            onRetryMark: viewModel.markPaid,
                          ),
                        ),
                      ),
                    ),
                  ),
                  _InvoiceBar(
                    state: state,
                    maxContentWidth: context.isTablet ? 640 : null,
                    onMarkPaid: () => _confirmMarkPaid(context, ref),
                    onReview: () => _openReview(context),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildWide(
    BuildContext context,
    WidgetRef ref,
    InvoiceState state,
    InvoiceViewModel viewModel,
  ) {
    final invoice = state.invoice!;
    final paid = state.isPaid;
    final ctaLabel = !paid
        ? 'Tandai lunas'
        : state.hasReview
        ? 'Lihat ulasan'
        : 'Beri ulasan';
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720 + 24 + 360),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _InvoiceContent(
                  state: state,
                  onRetryMark: viewModel.markPaid,
                  showTotals: false,
                ),
              ),
              const SizedBox(width: 24),
              SizedBox(
                width: 360,
                child: InvoiceSummaryCard(
                  paid: paid,
                  subtotal: invoice.subtotal,
                  discount: invoice.discount,
                  total: invoice.total,
                  voucherCode: state.voucherCode,
                  workshopName: state.workshopName,
                  issuedLine:
                      'Diterbitkan ${_InvoiceContent._stamp(invoice.issuedAt)}',
                  ctaLabel: ctaLabel,
                  isLoading: state.isMarking,
                  onCta: paid
                      ? () => _openReview(context)
                      : () => _confirmMarkPaid(context, ref),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InvoiceBar extends StatelessWidget {
  const _InvoiceBar({
    required this.state,
    required this.onMarkPaid,
    required this.onReview,
    this.maxContentWidth,
  });

  final double? maxContentWidth;
  final InvoiceState state;
  final VoidCallback onMarkPaid;
  final VoidCallback onReview;

  @override
  Widget build(BuildContext context) {
    final invoice = state.invoice!;
    final paid = state.isPaid;
    final label = !paid
        ? 'Tandai lunas'
        : state.hasReview
        ? 'Lihat ulasan'
        : 'Beri ulasan';

    return ConfirmBar(
      totalLabel: paid ? 'Total dibayar' : 'Total tagihan',
      totalValue: CurrencyFormatter.format(invoice.total),
      ctaLabel: label,
      loadingLabel: 'Menandai lunas…',
      enabled: true,
      isLoading: state.isMarking,
      maxContentWidth: maxContentWidth,
      onConfirm: paid ? onReview : onMarkPaid,
    );
  }
}

class _InvoiceContent extends StatelessWidget {
  const _InvoiceContent({
    required this.state,
    required this.onRetryMark,
    this.showTotals = true,
  });

  final bool showTotals;
  final InvoiceState state;
  final Future<bool> Function() onRetryMark;

  static String _stamp(DateTime at) =>
      '${DateFormatter.format(at)} · ${TimeFormatter.format(at)}';

  @override
  Widget build(BuildContext context) {
    final ext = TsThemeExtension.of(context);
    final textTheme = Theme.of(context).textTheme;
    final invoice = state.invoice!;
    final booking = state.booking!;
    final paid = state.isPaid;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (paid && invoice.paidAt != null) ...[
          PaidBanner(paidLine: 'Dibayar ${_stamp(invoice.paidAt!)}'),
          const SizedBox(height: 16),
        ],
        if (state.markFailed) ...[
          _MarkError(onRetry: onRetryMark),
          const SizedBox(height: 16),
        ],
        InvoiceHeaderCard(
          bookingCode: booking.code,
          issuedLine: 'Diterbitkan ${_stamp(invoice.issuedAt)}',
          paid: paid,
          workshopName: state.workshopName,
          workshopAddress: state.workshopAddress,
        ),
        const SizedBox(height: 16),
        for (final unit in booking.units)
          if (_linesFor(invoice, unit).isNotEmpty) ...[
            PriceBreakdownInvoice(
              unitTitle:
                  '${unit.motorSnapshot.nickname} · '
                  '${unit.motorSnapshot.plateNumber}',
              lines: _linesFor(invoice, unit),
            ),
            const SizedBox(height: 12),
          ],
        if (showTotals) ...[
          const SizedBox(height: 4),
          InvoiceTotals(
            subtotal: invoice.subtotal,
            discount: invoice.discount,
            total: invoice.total,
            paid: paid,
            voucherCode: state.voucherCode,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              ExcludeSemantics(
                child: Icon(
                  Icons.payments_outlined,
                  size: 18,
                  color: ext.textMuted,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  paid ? 'Dibayar di bengkel' : 'Bayar di bengkel',
                  style: textTheme.bodySmall?.copyWith(color: ext.textMuted),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  static List<InvoiceLine> _linesFor(Invoice invoice, BookingUnit unit) => [
    for (final line in invoice.lines)
      if (line.unitCode == unit.unitCode) line,
  ];
}

class _MarkError extends StatelessWidget {
  const _MarkError({required this.onRetry});

  final Future<bool> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    final ext = TsThemeExtension.of(context);
    final textTheme = Theme.of(context).textTheme;

    return Semantics(
      liveRegion: true,
      container: true,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: ext.dangerSoft,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.error_outline_rounded, color: ext.dangerText),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Gagal menandai lunas. Coba lagi.',
                    style: textTheme.bodyMedium?.copyWith(
                      color: ext.dangerText,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TsButton(
              label: 'Coba lagi',
              type: TsButtonType.outline,
              fullWidth: false,
              compact: true,
              onPressed: onRetry,
            ),
          ],
        ),
      ),
    );
  }
}

class _InvoiceSkeleton extends StatelessWidget {
  const _InvoiceSkeleton();

  @override
  Widget build(BuildContext context) {
    return Semantics(
      liveRegion: true,
      label: 'Memuat invoice',
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              child: Column(
                children: const [
                  SkeletonBlock(
                    height: 132,
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                  ),
                  SizedBox(height: 16),
                  SkeletonBlock(
                    height: 148,
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                  ),
                  SizedBox(height: 12),
                  SkeletonBlock(
                    height: 148,
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                  ),
                  SizedBox(height: 16),
                  SkeletonBlock(
                    height: 96,
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                  ),
                ],
              ),
            ),
          ),
          const ConfirmBar(
            totalLabel: 'Total tagihan',
            totalValue: '—',
            ctaLabel: 'Tandai lunas',
            enabled: false,
            isLoading: false,
            reasonLine: InvoiceState.loadingReason,
            onConfirm: _noop,
          ),
        ],
      ),
    );
  }
}

void _noop() {}
