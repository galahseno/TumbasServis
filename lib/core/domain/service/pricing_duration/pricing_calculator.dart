import 'package:tumbas_servis/core/domain/model/catalog/part.dart';
import 'package:tumbas_servis/core/domain/model/catalog/service_type.dart';
import 'package:tumbas_servis/core/domain/model/catalog/voucher.dart';

class PriceBreakdown {
  const PriceBreakdown({
    required this.subtotal,
    required this.discount,
    required this.total,
  });

  final int subtotal;
  final int discount;
  final int total;
}

class PricingCalculator {
  const PricingCalculator();

  int unitSubtotal({
    required List<ServiceType> services,
    required List<Part> parts,
  }) {
    final serviceSum = services.fold<int>(0, (sum, s) => sum + s.price);
    final partSum = parts.fold<int>(0, (sum, p) => sum + p.price);
    return serviceSum + partSum;
  }

  int fleetSubtotal(List<int> unitSubtotals) =>
      unitSubtotals.fold<int>(0, (sum, s) => sum + s);

  int voucherDiscount({required int subtotal, required Voucher voucher}) {
    return switch (voucher.discountType) {
      DiscountType.percent => (subtotal * voucher.discountValue / 100).round(),
      DiscountType.flat => voucher.discountValue,
      DiscountType.unknown => 0,
    };
  }

  PriceBreakdown breakdown({
    required List<int> unitSubtotals,
    Voucher? voucher,
  }) {
    final subtotal = fleetSubtotal(unitSubtotals);
    final discount = voucher == null
        ? 0
        : voucherDiscount(subtotal: subtotal, voucher: voucher);
    return PriceBreakdown(
      subtotal: subtotal,
      discount: discount,
      total: subtotal - discount,
    );
  }
}
