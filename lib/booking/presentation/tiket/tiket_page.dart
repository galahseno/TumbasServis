import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tumbas_servis/app/navigation/routes.dart';
import 'package:tumbas_servis/booking/presentation/di/booking_presentation_module.dart';
import 'package:tumbas_servis/booking/presentation/tiket/components/success_header.dart';
import 'package:tumbas_servis/booking/presentation/tiket/components/ticket_actions.dart';
import 'package:tumbas_servis/booking/presentation/tiket/components/ticket_card.dart';
import 'package:tumbas_servis/booking/presentation/tiket/components/ticket_units_panel.dart';
import 'package:tumbas_servis/booking/presentation/utils/tiket_display.dart';
import 'package:tumbas_servis/core/presentation/components/error_state.dart';
import 'package:tumbas_servis/core/presentation/components/max_width_box.dart';
import 'package:tumbas_servis/core/presentation/components/ts_snackbar.dart';
import 'package:tumbas_servis/core/presentation/utils/currency_formatter.dart';
import 'package:tumbas_servis/core/presentation/utils/window_size_class.dart';

class TiketPage extends ConsumerStatefulWidget {
  const TiketPage({required this.bookingId, super.key});

  final String bookingId;

  @override
  ConsumerState<TiketPage> createState() => _TiketPageState();
}

class _TiketPageState extends ConsumerState<TiketPage> {
  @override
  void initState() {
    super.initState();
    Future(
      () => ref.read(tiketViewModelProvider.notifier).load(widget.bookingId),
    );
  }

  void _goHome() => context.go(Routes.home);

  @override
  Widget build(BuildContext context) {
    ref.listen(tiketViewModelProvider.select((s) => s.copyCount), (
      previous,
      next,
    ) {
      if (next > (previous ?? 0)) {
        TsSnackbar.success(context, 'Kode booking disalin');
      }
    });

    final state = ref.watch(tiketViewModelProvider);
    final viewModel = ref.read(tiketViewModelProvider.notifier);
    final scheme = Theme.of(context).colorScheme;

    final booking = state.booking;
    final workshop = state.workshop;
    final ready = !state.isLoading && !state.hasError;

    final sizeClass = context.windowSizeClass;
    final isSplit =
        sizeClass.isAtLeast(WindowSizeClass.expanded) && !state.hasError;
    final isMedium = sizeClass == WindowSizeClass.medium;
    final canTrack = ready && booking != null;

    final lines = (ready && booking != null)
        ? buildTicketUnitLines(booking: booking, serviceById: state.serviceById)
        : null;

    final actions = TicketActions(
      trackEnabled: canTrack,
      pane: isSplit,
      maxContentWidth: isMedium ? _ticketMaxWidth : null,
      onTrack: () => context.go(Routes.bookingDetail(widget.bookingId)),
      onHome: _goHome,
    );

    Widget ticketCard({required double margin}) {
      if (!ready || booking == null || workshop == null) {
        return TicketCardSkeleton(
          showUnits: !isSplit,
          horizontalMargin: margin,
        );
      }
      return TicketCard(
        code: booking.code,
        units: lines ?? const [],
        showUnits: !isSplit,
        horizontalMargin: margin,
        workshopName: workshop.name,
        scheduleLine: ticketScheduleLine(booking),
        totalLabel:
            'Total estimasi · Bayar di bengkel · '
            '${CurrencyFormatter.format(booking.total)}',
        semanticsLabel: ticketSemanticsLabel(
          booking: booking,
          workshopName: workshop.name,
        ),
        onCopy: viewModel.copyCode,
        onWorkshopTap: () => context.push(Routes.workshopDetail(workshop.id)),
      );
    }

    Widget body;
    if (state.hasError) {
      body = ErrorState(
        message: 'Tiket gagal dimuat. Coba lagi.',
        onRetry: () => viewModel.load(widget.bookingId),
        layout: ErrorStateLayout.fullPage,
      );
    } else if (isSplit) {
      body = SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 24),
        child: MaxWidthBox(
          maxWidth: 480 + 24 + 400 + 48,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 480,
                  child: Column(
                    children: [const SuccessHeader(), ticketCard(margin: 0)],
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  flex: 400,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Visibility(
                        visible: false,
                        maintainSize: true,
                        maintainAnimation: true,
                        maintainState: true,
                        child: ExcludeSemantics(child: SuccessHeader()),
                      ),
                      TicketUnitsPanel(lines: lines),
                      const SizedBox(height: 16),
                      actions,
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      body = _TicketScroll(
        card: ticketCard(margin: 16),
        maxWidth: isMedium ? _ticketMaxWidth : null,
      );
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _goHome();
      },
      child: Scaffold(
        backgroundColor: scheme.surface,
        body: SafeArea(
          child: Column(
            children: [
              Expanded(child: body),
              if (!isSplit) actions,
            ],
          ),
        ),
      ),
    );
  }
}

const _ticketMaxWidth = 560.0;

class _TicketScroll extends StatelessWidget {
  const _TicketScroll({required this.card, this.maxWidth});

  final Widget card;
  final double? maxWidth;

  @override
  Widget build(BuildContext context) {
    final content = Column(children: [const SuccessHeader(), card]);
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 16),
      child: maxWidth == null
          ? content
          : MaxWidthBox(maxWidth: maxWidth!, child: content),
    );
  }
}
