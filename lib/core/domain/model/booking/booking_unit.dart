import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tumbas_servis/core/domain/model/garage/motor.dart';
import 'package:tumbas_servis/core/domain/model/booking/status_event.dart';
import 'package:tumbas_servis/core/domain/model/booking/unit_status.dart';

part 'booking_unit.freezed.dart';

@freezed
abstract class BookingUnit with _$BookingUnit {
  const factory BookingUnit({
    required String unitCode,
    required String motorId,
    required Motor motorSnapshot,
    required List<String> serviceIds,
    required List<String> partIds,
    String? complaintNote,
    required UnitStatus status,
    required List<StatusEvent> statusHistory,
    String? mechanicId,
    required int subtotal,
    required int durationMin,
  }) = _BookingUnit;
}
