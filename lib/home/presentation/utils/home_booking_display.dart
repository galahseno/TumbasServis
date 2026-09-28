import 'package:tumbas_servis/core/domain/model/booking/booking.dart';
import 'package:tumbas_servis/core/domain/model/booking/unit_status.dart';
import 'package:tumbas_servis/core/presentation/utils/date_formatter.dart';
import 'package:tumbas_servis/home/presentation/home/state/home_state.dart';

extension HomeBookingsX on List<Booking> {
  Map<String, UnitStatus> get motorInServiceStatus {
    final map = <String, UnitStatus>{};
    for (final booking in this) {
      for (final unit in booking.units) {
        if (!unit.status.isTerminal) map[unit.motorId] = unit.status;
      }
    }
    return map;
  }
}

extension HomeBookingDisplayX on Booking {
  HomeActiveBookingDisplay toActiveBookingDisplay(
    Map<String, String> workshopNameById,
  ) {
    final statuses = units.map((u) => u.status).toList();
    final (label, caption) = statuses.majorityStatus;
    final workshopName = workshopNameById[workshopId] ?? '';
    final slot =
        sharedSlot ??
        (unitSlots?.values.isEmpty ?? true
            ? null
            : unitSlots!.values.reduce(
                (a, b) => a.date.isBefore(b.date) ? a : b,
              ));
    final scheduleLine = slot == null
        ? workshopName
        : '$workshopName · ${DateFormatter.formatShort(slot.date)} · '
              '${slot.hour.toString().padLeft(2, '0')}.00';
    return (
      booking: this,
      statusLabel: label,
      statusCaption: caption,
      scheduleLine: scheduleLine,
    );
  }
}

extension HomeUnitStatusesX on List<UnitStatus> {
  (String, String?) get majorityStatus {
    if (isEmpty) return ('', null);
    final counts = <UnitStatus, int>{};
    for (final s in this) {
      counts[s] = (counts[s] ?? 0) + 1;
    }
    final maxCount = counts.values.reduce((a, b) => a > b ? a : b);
    final tied = counts.entries.where((e) => e.value == maxCount).toList()
      ..sort((a, b) => a.key.stageIndex.compareTo(b.key.stageIndex));
    final majority = tied.first.key;

    if (counts.length == 1) {
      return (majority.displayLabel, null);
    }
    final minorityCount = length - maxCount;
    final minorityStatus = counts.entries
        .where((e) => e.key != majority)
        .reduce((a, b) => a.key.stageIndex < b.key.stageIndex ? a : b)
        .key;
    final caption =
        '$minorityCount motor masih ${minorityStatus.displayLabel.toLowerCase()}';
    return (majority.displayLabel, caption);
  }
}

extension UnitStatusDisplayX on UnitStatus {
  String get displayLabel => switch (this) {
    UnitStatus.terjadwal || UnitStatus.unknown => 'Terjadwal',
    UnitStatus.checkIn => 'Check-in',
    UnitStatus.diperiksa => 'Diperiksa',
    UnitStatus.dikerjakan => 'Dikerjakan',
    UnitStatus.qc => 'QC',
    UnitStatus.selesai => 'Selesai',
    UnitStatus.dibatalkan => 'Dibatalkan',
  };
}
