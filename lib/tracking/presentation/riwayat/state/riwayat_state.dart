import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking_status.dart';

part 'riwayat_state.freezed.dart';

enum RiwayatTab { mendatang, berlangsung, selesai, dibatalkan }

extension RiwayatTabX on RiwayatTab {
  String get label => switch (this) {
    RiwayatTab.mendatang => 'Mendatang',
    RiwayatTab.berlangsung => 'Berlangsung',
    RiwayatTab.selesai => 'Selesai',
    RiwayatTab.dibatalkan => 'Dibatalkan',
  };

  BookingStatus get status => switch (this) {
    RiwayatTab.mendatang => BookingStatus.terjadwal,
    RiwayatTab.berlangsung => BookingStatus.berlangsung,
    RiwayatTab.selesai => BookingStatus.selesai,
    RiwayatTab.dibatalkan => BookingStatus.dibatalkan,
  };

  static RiwayatTab fromStatus(BookingStatus status) => switch (status) {
    BookingStatus.terjadwal || BookingStatus.unknown => RiwayatTab.mendatang,
    BookingStatus.berlangsung => RiwayatTab.berlangsung,
    BookingStatus.selesai => RiwayatTab.selesai,
    BookingStatus.dibatalkan => RiwayatTab.dibatalkan,
  };
}

typedef HistoryEntry = ({
  Booking booking,
  String workshopName,
  DateTime moment,
});

@freezed
abstract class RiwayatState with _$RiwayatState {
  const factory RiwayatState({
    @Default(true) bool isLoading,
    @Default(false) bool hasError,
    @Default(<HistoryEntry>[]) List<HistoryEntry> allEntries,
    @Default(RiwayatTab.berlangsung) RiwayatTab selectedTab,
    String? motorFilterId,
    String? motorFilterLabel,
    String? selectedBookingId,
  }) = _RiwayatState;

  const RiwayatState._();

  List<HistoryEntry> get entries {
    final motorId = motorFilterId;
    if (motorId == null) return allEntries;
    return allEntries
        .where((e) => e.booking.units.any((u) => u.motorId == motorId))
        .toList();
  }

  int countFor(RiwayatTab tab) => entries
      .where((e) => RiwayatTabX.fromStatus(e.booking.status) == tab)
      .length;

  List<HistoryEntry> get visibleEntries {
    final tab = selectedTab;
    final list = entries
        .where((e) => RiwayatTabX.fromStatus(e.booking.status) == tab)
        .toList();
    list.sort(
      (a, b) => tab == RiwayatTab.mendatang
          ? a.moment.compareTo(b.moment)
          : b.moment.compareTo(a.moment),
    );
    return list;
  }

  String? get effectiveSelectedId {
    final visible = visibleEntries;
    if (visible.isEmpty) return null;
    final picked = selectedBookingId;
    if (picked != null && visible.any((e) => e.booking.id == picked)) {
      return picked;
    }
    return visible.first.booking.id;
  }

  RiwayatTab get defaultTab {
    if (countFor(RiwayatTab.berlangsung) > 0) return RiwayatTab.berlangsung;
    for (final tab in RiwayatTab.values) {
      if (countFor(tab) > 0) return tab;
    }
    return RiwayatTab.berlangsung;
  }
}
