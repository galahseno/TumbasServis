import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tumbas_servis/core/domain/model/garage/motor.dart';
import 'package:tumbas_servis/core/domain/model/workshop/time_slot.dart';
import 'package:tumbas_servis/core/domain/model/workshop/workshop.dart';

part 'pilih_jadwal_state.freezed.dart';

@freezed
abstract class PilihJadwalState with _$PilihJadwalState {
  const factory PilihJadwalState({
    @Default(true) bool isLoading,
    @Default(false) bool hasError,
    Workshop? workshop,
    @Default(<String, Motor>{}) Map<String, Motor> motorsById,
    DateTime? sharedDate,
    @Default(<TimeSlot>[]) List<TimeSlot> sharedSlots,
    @Default(false) bool sharedSlotsLoading,
    @Default(<String, DateTime>{}) Map<String, DateTime> unitDates,
    @Default(<String, List<TimeSlot>>{})
    Map<String, List<TimeSlot>> unitSlotsByMotor,
    @Default(<String>{}) Set<String> unitSlotsLoading,
    String? expandedMotorId,
    @Default(false) bool allFullSearching,
    DateTime? allFullNextDate,
  }) = _PilihJadwalState;
}
