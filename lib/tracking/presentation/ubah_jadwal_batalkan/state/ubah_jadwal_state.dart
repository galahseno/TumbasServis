import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking.dart';
import 'package:tumbas_servis/core/domain/model/workshop/time_slot.dart';

part 'ubah_jadwal_state.freezed.dart';

typedef UbahJadwalArgs = ({Booking booking, String workshopName, int bayCount});

@freezed
abstract class UbahJadwalState with _$UbahJadwalState {
  const factory UbahJadwalState({
    required DateTime selectedDate,
    @Default(true) bool isLoadingSlots,
    @Default(false) bool slotsError,
    @Default(<TimeSlot>[]) List<TimeSlot> slots,
    TimeSlot? selectedSlot,
    @Default(false) bool isSaving,
    @Default(false) bool saveFailed,
  }) = _UbahJadwalState;
}
