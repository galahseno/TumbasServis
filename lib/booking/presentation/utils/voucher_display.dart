import 'package:tumbas_servis/core/domain/model/catalog/voucher.dart';
import 'package:tumbas_servis/core/domain/service/voucher/voucher_eligibility_service.dart';

const _eligibilityService = VoucherEligibilityService();

class VoucherOption {
  const VoucherOption({
    required this.voucher,
    this.savingAmount,
    this.reasonText,
  });

  final Voucher voucher;
  final int? savingAmount;
  final String? reasonText;
}

typedef VoucherOptions = ({
  List<VoucherOption> eligible,
  List<VoucherOption> ineligible,
});

VoucherOptions evaluateVouchers({
  required List<Voucher> vouchers,
  required int unitCount,
  required int subtotal,
  required DateTime now,
}) {
  final eligible = <VoucherOption>[];
  final ineligible = <VoucherOption>[];
  for (final voucher in vouchers) {
    final result = _eligibilityService.evaluate(
      voucher: voucher,
      unitCount: unitCount,
      subtotal: subtotal,
      now: now,
    );
    if (result.isEligible) {
      eligible.add(
        VoucherOption(voucher: voucher, savingAmount: result.discountAmount),
      );
    } else {
      ineligible.add(
        VoucherOption(
          voucher: voucher,
          reasonText: _eligibilityService.shortfallMessage(
            voucher: voucher,
            result: result,
          ),
        ),
      );
    }
  }
  eligible.sort((a, b) => (b.savingAmount ?? 0).compareTo(a.savingAmount ?? 0));
  return (eligible: eligible, ineligible: ineligible);
}
