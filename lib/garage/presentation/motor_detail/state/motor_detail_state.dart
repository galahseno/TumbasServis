import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tumbas_servis/core/domain/model/booking/unit_status.dart';
import 'package:tumbas_servis/core/domain/model/garage/motor.dart';
import 'package:tumbas_servis/core/domain/model/garage/motor_model.dart';

part 'motor_detail_state.freezed.dart';

typedef MotorHistoryEntry = ({
  String bookingId,
  String bookingCode,
  String unitCode,
  String code,
  UnitStatus status,
  DateTime dateTime,
  String servicesSummary,
  int subtotal,
});

@freezed
abstract class MotorDetailState with _$MotorDetailState {
  const factory MotorDetailState({
    @Default(true) bool isLoading,
    @Default(false) bool hasError,
    Motor? motor,
    MotorModel? model,
    MotorHistoryEntry? activeEntry,
    @Default(<MotorHistoryEntry>[]) List<MotorHistoryEntry> pastHistory,
    @Default(false) bool isDeleting,
  }) = _MotorDetailState;

  const MotorDetailState._();

  bool get hasActiveBooking => activeEntry != null;
  UnitStatus? get inServiceStatus => activeEntry?.status;
  List<MotorHistoryEntry> get latestPastHistory => pastHistory.take(3).toList();
  bool get showSeeAllHistory => pastHistory.isNotEmpty || hasActiveBooking;
}
