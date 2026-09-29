import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tumbas_servis/app/navigation/routes.dart';
import 'package:tumbas_servis/booking/presentation/di/booking_presentation_module.dart';
import 'package:tumbas_servis/booking/presentation/tiket/components/success_header.dart';
import 'package:tumbas_servis/booking/presentation/tiket/components/ticket_actions.dart';
import 'package:tumbas_servis/booking/presentation/tiket/components/ticket_card.dart';
import 'package:tumbas_servis/booking/presentation/utils/tiket_display.dart';
import 'package:tumbas_servis/core/presentation/components/error_state.dart';
import 'package:tumbas_servis/core/presentation/components/ts_snackbar.dart';
import 'package:tumbas_servis/core/presentation/utils/currency_formatter.dart';

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

    Widget body;
    if (state.hasError) {
      body = ErrorState(
        message: 'Tiket gagal dimuat. Coba lagi.',
        onRetry: () => viewModel.load(widget.bookingId),
        layout: ErrorStateLayout.fullPage,
      );
    } else if (!ready || booking == null || workshop == null) {
      body = const _TicketScroll(card: TicketCardSkeleton());
    } else {
      body = _TicketScroll(
        card: TicketCard(
          code: booking.code,
          units: buildTicketUnitLines(
            booking: booking,
            serviceById: state.serviceById,
          ),
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
        ),
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
              TicketActions(
                trackEnabled: ready && booking != null,
                onTrack: () =>
                    context.go(Routes.bookingDetail(widget.bookingId)),
                onHome: _goHome,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TicketScroll extends StatelessWidget {
  const _TicketScroll({required this.card});

  final Widget card;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(children: [const SuccessHeader(), card]),
    );
  }
}
