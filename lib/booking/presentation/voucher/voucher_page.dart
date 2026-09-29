import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tumbas_servis/booking/presentation/di/booking_presentation_module.dart';
import 'package:tumbas_servis/booking/presentation/voucher/components/voucher_card.dart';
import 'package:tumbas_servis/booking/presentation/voucher/state/voucher_state.dart';
import 'package:tumbas_servis/booking/presentation/voucher/voucher_view_model.dart';
import 'package:tumbas_servis/core/presentation/components/empty_state.dart';
import 'package:tumbas_servis/core/presentation/components/error_state.dart';
import 'package:tumbas_servis/core/presentation/components/skeleton.dart';
import 'package:tumbas_servis/core/presentation/components/ts_app_bar.dart';
import 'package:tumbas_servis/core/presentation/components/ts_button.dart';
import 'package:tumbas_servis/core/presentation/theme/ts_theme_extension.dart';
import 'package:tumbas_servis/core/presentation/utils/currency_formatter.dart';

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
    return const Padding(
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

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 8),
            children: [
              if (state.eligible.isNotEmpty) ...[
                _SectionHeader('Bisa dipakai (${state.eligible.length})'),
                for (final option in state.eligible)
                  VoucherCard(
                    title: option.voucher.label,
                    subtitle: 'Kode ${option.voucher.code}',
                    selected: state.pendingVoucherId == option.voucher.id,
                    savingLabel:
                        'Hemat ${CurrencyFormatter.format(option.savingAmount ?? 0)}',
                    onTap: () => viewModel.selectPending(option.voucher.id),
                  ),
              ],
              if (state.ineligible.isNotEmpty) ...[
                _SectionHeader(
                  'Belum bisa dipakai (${state.ineligible.length})',
                ),
                for (final option in state.ineligible)
                  VoucherCard(
                    title: option.voucher.label,
                    subtitle: 'Kode ${option.voucher.code}',
                    selected: false,
                    enabled: false,
                    reasonLabel: option.reasonText,
                  ),
              ],
              _SectionHeader('Lainnya'),
              VoucherCard(
                title: 'Tidak pakai voucher',
                subtitle: '',
                selected: state.pendingVoucherId == null,
                onTap: () => viewModel.selectPending(null),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            border: Border(top: BorderSide(color: ext.borderDefault)),
          ),
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
        ),
      ],
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
