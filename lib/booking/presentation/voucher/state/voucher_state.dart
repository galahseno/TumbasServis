import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tumbas_servis/booking/presentation/utils/voucher_display.dart';

part 'voucher_state.freezed.dart';

@freezed
abstract class VoucherState with _$VoucherState {
  const factory VoucherState({
    @Default(true) bool isLoading,
    @Default(false) bool hasError,
    @Default(<VoucherOption>[]) List<VoucherOption> eligible,
    @Default(<VoucherOption>[]) List<VoucherOption> ineligible,
    @Default(0) int subtotal,
    String? appliedVoucherId,
    String? pendingVoucherId,
    @Default(false) bool applying,
    @Default(false) bool applied,
  }) = _VoucherState;
}
