import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking_draft.dart';
import 'package:tumbas_servis/core/domain/model/booking/unit_status.dart';
import 'package:tumbas_servis/core/domain/model/catalog/promo.dart';
import 'package:tumbas_servis/core/domain/model/garage/motor.dart';

part 'home_state.freezed.dart';

typedef HomeActiveBookingDisplay = ({
  Booking booking,
  String statusLabel,
  String? statusCaption,
  String scheduleLine,
});

typedef HomeDraftDisplay = ({
  BookingDraft draft,
  String summaryLine,
  String expiryLabel,
  bool expiringSoon,
});

@freezed
abstract class HomeState with _$HomeState {
  const factory HomeState({
    @Default(true) bool isLoading,
    @Default(false) bool hasError,
    @Default('') String userName,
    @Default(0) int unreadCount,
    @Default(<Motor>[]) List<Motor> motors,
    @Default(<String, UnitStatus>{})
    Map<String, UnitStatus> motorInServiceStatus,
    @Default(<HomeActiveBookingDisplay>[])
    List<HomeActiveBookingDisplay> activeBookings,
    @Default(0) int activeBookingsTotalCount,
    HomeDraftDisplay? draft,
    @Default(<Promo>[]) List<Promo> promos,
  }) = _HomeState;

  const HomeState._();

  bool get isEmpty => !isLoading && activeBookings.isEmpty && draft == null;
}
