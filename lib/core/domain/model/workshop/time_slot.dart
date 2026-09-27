import 'package:freezed_annotation/freezed_annotation.dart';

part 'time_slot.freezed.dart';

@freezed
abstract class TimeSlot with _$TimeSlot {
  const TimeSlot._();

  const factory TimeSlot({
    required DateTime date,
    required int hour,
    required int capacity,
    required int booked,
  }) = _TimeSlot;

  int get remaining => capacity - booked;
}
