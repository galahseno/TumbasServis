import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking_unit.dart';
import 'package:tumbas_servis/core/domain/model/booking/unit_status.dart';
import 'package:tumbas_servis/core/domain/model/workshop/mechanic.dart';
import 'package:tumbas_servis/core/domain/model/workshop/time_slot.dart';
import 'package:tumbas_servis/booking/presentation/utils/schedule_display.dart';
import 'package:tumbas_servis/tracking/presentation/utils/tracking_display.dart';

part 'lacak_unit_state.freezed.dart';

@freezed
abstract class LacakUnitState with _$LacakUnitState {
  const factory LacakUnitState({
    @Default(true) bool isLoading,
    @Default(false) bool hasError,
    Booking? booking,
    BookingUnit? unit,
    Mechanic? mechanic,
    @Default('') String servicesSummary,
    @Default(false) bool isDemoBusy,
  }) = _LacakUnitState;

  const LacakUnitState._();

  UnitStatus? get status => unit?.status;
  bool get isCancelled => status == UnitStatus.dibatalkan;
  bool get isCompleted => status == UnitStatus.selesai;
  bool get isTerminal => status?.isTerminal ?? false;

  bool get canAdvance => unit != null && !isTerminal && !isDemoBusy;
  bool get canReset =>
      unit != null && status != UnitStatus.dibatalkan && !isDemoBusy;
  bool get showDemoShortcut => unit != null && !isCancelled;

  DateTime? get estimatedFinish {
    final b = booking;
    final u = unit;
    if (b == null || u == null) return null;
    final TimeSlot? slot = unitSlot(b, u);
    if (slot == null) return null;
    return slotDateTime(slot).add(Duration(minutes: u.durationMin));
  }

  DateTime? get completedAt =>
      unit == null ? null : eventFor(unit!, UnitStatus.selesai)?.timestamp;
}
