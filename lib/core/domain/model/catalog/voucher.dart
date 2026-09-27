import 'package:freezed_annotation/freezed_annotation.dart';

part 'voucher.freezed.dart';

enum DiscountType { percent, flat, unknown }

extension DiscountTypeX on DiscountType {
  static DiscountType fromString(String? value) => switch (value) {
    'percent' => DiscountType.percent,
    'flat' => DiscountType.flat,
    _ => DiscountType.unknown,
  };
}

@freezed
abstract class Voucher with _$Voucher {
  const factory Voucher({
    required String id,
    required String code,
    required String label,
    required DiscountType discountType,
    required int discountValue,
    int? minUnits,
    int? minSubtotal,
    required DateTime validUntil,
  }) = _Voucher;
}
