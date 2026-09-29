import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tumbas_servis/core/data/service/demo_mode_controller.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking_unit.dart';
import 'package:tumbas_servis/core/domain/model/booking/unit_status.dart';

part 'demo_mode_state.freezed.dart';

@freezed
abstract class DemoModeState with _$DemoModeState {
  const factory DemoModeState({
    @Default(true) bool isLoading,
    @Default(false) bool hasError,
    String? bookingId,
    @Default('') String bookingCode,
    @Default([]) List<BookingUnit> units,
    @Default(TrackingSpeed.detik15) TrackingSpeed speed,
    @Default(false) bool errorArmed,

    @Default(false) bool isBusy,
    @Default(false) bool isResetting,
  }) = _DemoModeState;

  const DemoModeState._();

  bool get hasActiveBooking => bookingId != null && units.isNotEmpty;

  bool get canAdvanceAny =>
      hasActiveBooking && units.any((u) => !u.status.isTerminal);

  bool get canResetAny =>
      hasActiveBooking && units.any((u) => u.status != UnitStatus.terjadwal);

  static const noActiveBookingReason =
      'Belum ada booking berlangsung. Buat booking dulu untuk memakai '
      'kontrol status.';
}
