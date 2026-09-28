import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking_draft.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking_status.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking_unit.dart';
import 'package:tumbas_servis/core/domain/model/workshop/time_slot.dart';

part 'booking.freezed.dart';

@freezed
abstract class Booking with _$Booking {
  const factory Booking({
    required String id,
    required String code,
    required String userId,
    required String workshopId,
    required List<BookingUnit> units,
    required ScheduleMode scheduleMode,
    TimeSlot? sharedSlot,
    Map<String, TimeSlot>? unitSlots,
    required BookingStatus status,
    String? voucherId,
    required int subtotal,
    required int discount,
    required int total,
    required DateTime createdAt,
    DateTime? completedAt,
  }) = _Booking;
}
