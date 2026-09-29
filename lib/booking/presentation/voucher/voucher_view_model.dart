import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tumbas_servis/booking/presentation/di/booking_presentation_module.dart';
import 'package:tumbas_servis/booking/presentation/utils/ringkasan_display.dart';
import 'package:tumbas_servis/booking/presentation/utils/voucher_display.dart';
import 'package:tumbas_servis/booking/presentation/voucher/state/voucher_state.dart';
import 'package:tumbas_servis/catalog/data/di/catalog_data_module.dart';
import 'package:tumbas_servis/core/data/di/core_data_module.dart';
import 'package:tumbas_servis/core/domain/model/catalog/voucher.dart';
import 'package:tumbas_servis/core/domain/model/result.dart';
import 'package:tumbas_servis/core/domain/service/pricing_duration/pricing_calculator.dart';

const _pricingCalculator = PricingCalculator();

class VoucherViewModel extends Notifier<VoucherState> {
  @override
  VoucherState build() {
    _load();
    return const VoucherState();
  }

  bool get hasPendingChange => state.pendingVoucherId != state.appliedVoucherId;

  Future<void> _load() async {
    await Future<void>.value();
    if (!ref.mounted) return;
    final draft = ref.read(bookingDraftProvider);
    if (draft == null) {
      state = state.copyWith(isLoading: false, hasError: true);
      return;
    }

    final vouchersResult = await ref
        .read(catalogRepositoryProvider)
        .getVouchers();
    if (!ref.mounted) return;
    if (vouchersResult is Error<List<Voucher>>) {
      state = state.copyWith(isLoading: false, hasError: true);
      return;
    }

    final ringkasan = ref.read(ringkasanViewModelProvider);
    final units = buildUnitLines(
      draft: draft,
      motorsById: ringkasan.motorsById,
      serviceById: ringkasan.serviceById,
      partById: ringkasan.partById,
    );
    final subtotal = _pricingCalculator.fleetSubtotal(
      units.map((u) => u.subtotal).toList(),
    );
    final now = ref.read(clockProvider).now();
    final options = evaluateVouchers(
      vouchers: (vouchersResult as Ok<List<Voucher>>).value,
      unitCount: units.length,
      subtotal: subtotal,
      now: now,
    );

    state = state.copyWith(
      isLoading: false,
      hasError: false,
      eligible: options.eligible,
      ineligible: options.ineligible,
      subtotal: subtotal,
      appliedVoucherId: draft.voucherId,
      pendingVoucherId: draft.voucherId,
    );
  }

  void selectPending(String? voucherId) {
    state = state.copyWith(pendingVoucherId: voucherId);
  }

  Future<void> apply() async {
    if (!hasPendingChange || state.applying) return;
    state = state.copyWith(applying: true);
    await ref
        .read(bookingDraftProvider.notifier)
        .setVoucher(state.pendingVoucherId);
    if (!ref.mounted) return;
    state = state.copyWith(
      applying: false,
      applied: true,
      appliedVoucherId: state.pendingVoucherId,
    );
  }
}
