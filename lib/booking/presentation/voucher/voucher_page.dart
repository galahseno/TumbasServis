import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tumbas_servis/booking/presentation/di/booking_presentation_module.dart';
import 'package:tumbas_servis/booking/presentation/voucher/components/voucher_card.dart';
import 'package:tumbas_servis/booking/presentation/voucher/state/voucher_state.dart';
import 'package:tumbas_servis/booking/presentation/voucher/voucher_view_model.dart';
import 'package:tumbas_servis/core/presentation/components/empty_state.dart';
import 'package:tumbas_servis/core/presentation/components/error_state.dart';
import 'package:tumbas_servis/core/presentation/components/max_width_box.dart';
import 'package:tumbas_servis/core/presentation/components/skeleton.dart';
import 'package:tumbas_servis/core/presentation/components/ts_app_bar.dart';
import 'package:tumbas_servis/core/presentation/components/ts_button.dart';
import 'package:tumbas_servis/core/presentation/theme/ts_theme_extension.dart';
import 'package:tumbas_servis/core/presentation/utils/currency_formatter.dart';
import 'package:tumbas_servis/core/presentation/utils/window_size_class.dart';

class VoucherPage extends ConsumerWidget {
  const VoucherPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(voucherViewModelProvider, (previous, next) {
      if (next.applied && previous?.applied != true) {
        Navigator.of(context).pop();
      }
    });

    final state = ref.watch(voucherViewModelProvider);
    final viewModel = ref.read(voucherViewModelProvider.notifier);
    final scheme = Theme.of(context).colorScheme;

    Widget body;
    if (state.hasError) {
      body = ErrorState(
        message: 'Voucher gagal dimuat. Coba lagi.',
        onRetry: () => ref.invalidate(voucherViewModelProvider),
        layout: ErrorStateLayout.fullPage,
      );
    } else if (state.isLoading) {
      body = const _LoadingBody();
    } else if (state.eligible.isEmpty && state.ineligible.isEmpty) {
      body = const EmptyState(
        icon: Icons.local_offer_outlined,
        title: 'Belum ada voucher',
        body: 'Voucher dari promo akan muncul di sini.',
      );
    } else {
      body = _VoucherBody(state: state, viewModel: viewModel);
    }

    return Scaffold(
      backgroundColor: scheme.surface,
      appBar: TsAppBar.back(title: 'Pilih voucher'),
      body: SafeArea(top: false, child: body),
    );
  }
}

class _LoadingBody extends StatelessWidget {
  const _LoadingBody();

  @override
  Widget build(BuildContext context) {
    return const MaxWidthBox(
      maxWidth: 936,
      child: Padding(
        padding: EdgeInsets.fromLTRB(20, 12, 20, 12),
        child: Column(
          children: [
            SkeletonBlock(height: 96),
            SizedBox(height: 12),
            SkeletonBlock(height: 96),
            SizedBox(height: 12),
            SkeletonBlock(height: 96),
          ],
        ),
      ),
    );
  }
}

class _VoucherBody extends StatelessWidget {
  const _VoucherBody({required this.state, required this.viewModel});

  final VoucherState state;
  final VoucherViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final ext = TsThemeExtension.of(context);
    final textTheme = Theme.of(context).textTheme;

    int? pendingSaving;
    for (final option in state.eligible) {
      if (option.voucher.id == state.pendingVoucherId) {
        pendingSaving = option.savingAmount ?? 0;
        break;
      }
    }
    final preview = state.eligible.isEmpty
        ? 'Belum ada voucher yang berlaku'
        : pendingSaving != null && pendingSaving > 0
        ? 'Hemat ${CurrencyFormatter.format(pendingSaving)} · '
              'Total estimasi ${CurrencyFormatter.format(state.subtotal - pendingSaving)}'
        : 'Total estimasi ${CurrencyFormatter.format(state.subtotal)}';

    final sizeClass = context.windowSizeClass;
    final isGrid = sizeClass.isAtLeast(WindowSizeClass.expanded);
    final maxWidth = switch (sizeClass) {
      WindowSizeClass.compact => null,
      WindowSizeClass.medium => 560.0,
      WindowSizeClass.expanded || WindowSizeClass.large => 936.0,
    };

    final eligibleCards = [
      for (final option in state.eligible)
        VoucherCard(
          title: option.voucher.label,
          subtitle: 'Kode ${option.voucher.code}',
          selected: state.pendingVoucherId == option.voucher.id,
          savingLabel:
              'Hemat ${CurrencyFormatter.format(option.savingAmount ?? 0)}',
          margin: isGrid ? EdgeInsets.zero : _cardMargin,
          onTap: () => viewModel.selectPending(option.voucher.id),
        ),
    ];
    final ineligibleCards = [
      for (final option in state.ineligible)
        VoucherCard(
          title: option.voucher.label,
          subtitle: 'Kode ${option.voucher.code}',
          selected: false,
          enabled: false,
          reasonLabel: option.reasonText,
          margin: isGrid ? EdgeInsets.zero : _cardMargin,
        ),
    ];
    final noVoucherCard = VoucherCard(
      title: 'Tidak pakai voucher',
      subtitle: '',
      selected: state.pendingVoucherId == null,
      margin: isGrid ? EdgeInsets.zero : _cardMargin,
      onTap: () => viewModel.selectPending(null),
    );

    Widget cards(List<Widget> items) =>
        isGrid ? _TwoColumnGrid(children: items) : Column(children: items);

    final sections = <Widget>[
      if (state.eligible.isNotEmpty) ...[
        _SectionHeader('Bisa dipakai (${state.eligible.length})'),
        cards(eligibleCards),
      ],
      if (state.ineligible.isNotEmpty) ...[
        _SectionHeader('Belum bisa dipakai (${state.ineligible.length})'),
        cards(ineligibleCards),
      ],
      const _SectionHeader('Lainnya'),
      isGrid
          ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: noVoucherCard,
            )
          : noVoucherCard,
    ];

    final footerRow = Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
      child: Row(
        children: [
          Expanded(
            child: Semantics(
              liveRegion: true,
              child: Text(
                preview,
                style: textTheme.bodyMedium?.copyWith(color: ext.textBody),
              ),
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 140,
            child: TsButton(
              label: 'Terapkan',
              fullWidth: false,
              isLoading: state.applying,
              onPressed: (viewModel.hasPendingChange && !state.applying)
                  ? viewModel.apply
                  : null,
            ),
          ),
        ],
      ),
    );

    return Column(
      children: [
        Expanded(
          child: maxWidth == null
              ? ListView(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  children: sections,
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: MaxWidthBox(
                    maxWidth: maxWidth,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: sections,
                    ),
                  ),
                ),
        ),
        DecoratedBox(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            border: Border(top: BorderSide(color: ext.borderDefault)),
          ),
          child: maxWidth == null
              ? footerRow
              : MaxWidthBox(maxWidth: maxWidth, child: footerRow),
        ),
      ],
    );
  }
}

const _cardMargin = EdgeInsets.symmetric(horizontal: 20, vertical: 6);

class _TwoColumnGrid extends StatelessWidget {
  const _TwoColumnGrid({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          for (var i = 0; i < children.length; i += 2)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(child: children[i]),
                    const SizedBox(width: 16),
                    Expanded(
                      child: i + 1 < children.length
                          ? children[i + 1]
                          : const SizedBox.shrink(),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    final ext = TsThemeExtension.of(context);
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
      child: Text(
        label,
        style: textTheme.labelLarge?.copyWith(color: ext.textMuted),
      ),
    );
  }
}
