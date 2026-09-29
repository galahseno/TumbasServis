import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking_draft.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking_status.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking_unit.dart';
import 'package:tumbas_servis/core/domain/model/booking/unit_status.dart';

part 'detail_booking_state.freezed.dart';

@freezed
abstract class DetailBookingState with _$DetailBookingState {
  const factory DetailBookingState({
    @Default(true) bool isLoading,
    @Default(false) bool hasError,
    Booking? booking,
    @Default('') String workshopName,
    @Default(0) int bayCount,
    @Default(<String, String>{}) Map<String, String> unitMeta,
    @Default(false) bool invoicePaid,
    @Default(false) bool hasReview,
    @Default(false) bool isMutating,
  }) = _DetailBookingState;

  const DetailBookingState._();

  static const checkedInReschedule =
      'Sudah check-in — jadwal tidak bisa diubah';
  static const checkedInCancel =
      'Sudah check-in — booking tidak bisa dibatalkan';
  static const splitReschedule = 'Jadwal per motor belum bisa diubah di demo';
  static const unpaidReview = 'Tandai lunas di invoice dulu';

  BookingStatus? get status => booking?.status;

  bool get isSplit => booking?.scheduleMode == ScheduleMode.split;

  List<BookingUnit> get terjadwalUnits => [
    for (final unit in booking?.units ?? const <BookingUnit>[])
      if (unit.status == UnitStatus.terjadwal) unit,
  ];

  bool get showScheduleActions =>
      status == BookingStatus.terjadwal || status == BookingStatus.berlangsung;

  bool get canReschedule =>
      status == BookingStatus.terjadwal && !isSplit && !isMutating;

  String? get rescheduleDisabledReason {
    if (status != BookingStatus.terjadwal) return checkedInReschedule;
    if (isSplit) return splitReschedule;
    return null;
  }

  bool get canCancel => terjadwalUnits.isNotEmpty && !isMutating;

  String? get cancelDisabledReason =>
      terjadwalUnits.isEmpty ? checkedInCancel : null;

  bool get canCancelWhole => status == BookingStatus.terjadwal;

  bool get canReview => invoicePaid && !hasReview;

  DateTime? get cancelledAt {
    DateTime? latest;
    for (final unit in booking?.units ?? const <BookingUnit>[]) {
      for (final event in unit.statusHistory) {
        if (event.status != UnitStatus.dibatalkan) continue;
        if (latest == null || event.timestamp.isAfter(latest)) {
          latest = event.timestamp;
        }
      }
    }
    return latest;
  }
}
