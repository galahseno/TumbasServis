import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tumbas_servis/booking/data/di/booking_data_module.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking.dart';
import 'package:tumbas_servis/core/domain/model/result.dart';
import 'package:tumbas_servis/core/domain/model/workshop/workshop.dart';
import 'package:tumbas_servis/tracking/presentation/riwayat/state/riwayat_state.dart';
import 'package:tumbas_servis/tracking/presentation/utils/tracking_display.dart';
import 'package:tumbas_servis/workshop/data/di/workshop_data_module.dart';

class RiwayatViewModel extends Notifier<RiwayatState> {
  RiwayatViewModel(this.motorId);

  final String? motorId;

  bool _tabPicked = false;

  @override
  RiwayatState build() {
    _load();
    return RiwayatState(motorFilterId: motorId);
  }

  Future<void> retry() async {
    state = state.copyWith(isLoading: true, hasError: false);
    await _load();
  }

  Future<void> refresh() => _load();

  void selectTab(RiwayatTab tab) {
    _tabPicked = true;
    state = state.copyWith(selectedTab: tab);
  }

  void clearMotorFilter() {
    state = state.copyWith(motorFilterId: null, motorFilterLabel: null);
    if (!_tabPicked) state = state.copyWith(selectedTab: state.defaultTab);
  }

  Future<void> _load() async {
    final bookingsResult = await ref
        .read(bookingRepositoryProvider)
        .getBookings();
    final workshopsResult = await ref
        .read(workshopRepositoryProvider)
        .getWorkshops();
    if (!ref.mounted) return;

    if (bookingsResult is! Ok<List<Booking>> ||
        workshopsResult is! Ok<List<Workshop>>) {
      state = state.copyWith(isLoading: false, hasError: true);
      return;
    }

    final workshopNames = {
      for (final workshop in workshopsResult.value) workshop.id: workshop.name,
    };
    final entries = [
      for (final booking in bookingsResult.value)
        (
          booking: booking,
          workshopName: workshopNames[booking.workshopId] ?? '',
          moment: bookingMoment(booking),
        ),
    ];

    String? label;
    final filterId = state.motorFilterId;
    if (filterId != null) {
      for (final booking in bookingsResult.value) {
        for (final unit in booking.units) {
          if (unit.motorId == filterId) {
            label = unit.motorSnapshot.nickname;
          }
        }
      }
    }

    var next = state.copyWith(
      isLoading: false,
      hasError: false,
      allEntries: entries,
      motorFilterLabel: label,
    );
    if (!_tabPicked) next = next.copyWith(selectedTab: next.defaultTab);
    state = next;
  }
}
