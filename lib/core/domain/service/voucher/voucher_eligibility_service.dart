import 'package:tumbas_servis/core/domain/model/catalog/voucher.dart';
import 'package:tumbas_servis/core/domain/service/pricing_duration/pricing_calculator.dart';

enum VoucherIneligibilityReason { minUnitsNotMet, minSubtotalNotMet, expired }

class VoucherEligibilityResult {
  const VoucherEligibilityResult.eligible({required this.discountAmount})
    : isEligible = true,
      reason = null,
      missingUnits = null,
      missingSubtotalAmount = null;

  const VoucherEligibilityResult.ineligible({
    required this.reason,
    this.missingUnits,
    this.missingSubtotalAmount,
  }) : isEligible = false,
       discountAmount = null;

  final bool isEligible;
  final int? discountAmount;
  final VoucherIneligibilityReason? reason;
  final int? missingUnits;
  final int? missingSubtotalAmount;
}

class VoucherEligibilityService {
  const VoucherEligibilityService();

  static const PricingCalculator _pricingCalculator = PricingCalculator();

  VoucherEligibilityResult evaluate({
    required Voucher voucher,
    required int unitCount,
    required int subtotal,
    required DateTime now,
  }) {
    if (voucher.validUntil.isBefore(now)) {
      return const VoucherEligibilityResult.ineligible(
        reason: VoucherIneligibilityReason.expired,
      );
    }

    final minUnits = voucher.minUnits;
    if (minUnits != null && unitCount < minUnits) {
      return VoucherEligibilityResult.ineligible(
        reason: VoucherIneligibilityReason.minUnitsNotMet,
        missingUnits: minUnits - unitCount,
      );
    }

    final minSubtotal = voucher.minSubtotal;
    if (minSubtotal != null && subtotal < minSubtotal) {
      return VoucherEligibilityResult.ineligible(
        reason: VoucherIneligibilityReason.minSubtotalNotMet,
        missingSubtotalAmount: minSubtotal - subtotal,
      );
    }

    return VoucherEligibilityResult.eligible(
      discountAmount: _pricingCalculator.voucherDiscount(
        subtotal: subtotal,
        voucher: voucher,
      ),
    );
  }

  String shortfallMessage({
    required Voucher voucher,
    required VoucherEligibilityResult result,
  }) {
    switch (result.reason) {
      case VoucherIneligibilityReason.minUnitsNotMet:
        return 'Butuh min. ${voucher.minUnits} motor';
      case VoucherIneligibilityReason.minSubtotalNotMet:
        return 'Min. belanja ${_formatRupiah(voucher.minSubtotal!)} '
            '— kurang ${_formatRupiah(result.missingSubtotalAmount!)}';
      case VoucherIneligibilityReason.expired:
        return 'Voucher sudah tidak berlaku';
      case null:
        return '';
    }
  }

  String _formatRupiah(int amount) {
    final digits = amount.toString();
    final buffer = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      if (i > 0 && (digits.length - i) % 3 == 0) buffer.write('.');
      buffer.write(digits[i]);
    }
    return 'Rp$buffer';
  }
}
