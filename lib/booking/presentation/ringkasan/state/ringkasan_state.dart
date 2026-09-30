import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tumbas_servis/core/domain/model/catalog/part.dart';
import 'package:tumbas_servis/core/domain/model/catalog/service_type.dart';
import 'package:tumbas_servis/core/domain/model/catalog/voucher.dart';
import 'package:tumbas_servis/core/domain/model/garage/motor.dart';
import 'package:tumbas_servis/core/domain/model/workshop/workshop.dart';

part 'ringkasan_state.freezed.dart';

@freezed
abstract class RingkasanState with _$RingkasanState {
  const factory RingkasanState({
    @Default(true) bool isLoading,
    @Default(false) bool hasError,
    Workshop? workshop,
    @Default(<String, Motor>{}) Map<String, Motor> motorsById,
    @Default(<String, ServiceType>{}) Map<String, ServiceType> serviceById,
    @Default(<String, Part>{}) Map<String, Part> partById,
    Voucher? voucher,
    String? removedVoucherId,
    String? voucherNotice,
    @Default(false) bool slotInvalid,
    String? slotInvalidTitle,
    String? slotInvalidBody,
    @Default(<String>{}) Set<String> expandedMotorIds,
    @Default(false) bool confirming,
    String? confirmError,
    String? confirmedBookingId,
  }) = _RingkasanState;
}
